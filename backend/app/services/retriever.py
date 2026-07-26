import time
import logging
import json
import re
from typing import Dict, Any
from app.config import settings
from app.services.embedding import get_embedding_service
from app.services.vector_store import get_vector_store_manager
from app.services.llm import get_llm_service
from app.services.prompt_builder import build_prompt
from app.models.schemas import ChatResponse, Source

logger = logging.getLogger(__name__)

def _parse_llm_json(raw: str) -> dict:
    """Parse the LLM's response, handling cases where it adds extra text."""
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        pass

    cleaned = re.sub(r"```(?:json)?", "", raw).strip()
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError:
        pass

    match = re.search(r"\{.*\}", raw, re.DOTALL)
    if match:
        try:
            return json.loads(match.group())
        except json.JSONDecodeError:
            pass

    logger.warning("Could not parse JSON from LLM chat response; using fallback.")
    return {
        "severity": "Caution",
        "verdict": "Unable to provide a clear verdict.",
        "explanation": raw[:500],
        "laws_cited": [],
        "case_lens": "N/A"
    }

class RetrieverService:
    def __init__(self):
        self.embedding_service = get_embedding_service()
        self.vector_store = get_vector_store_manager()
        self.llm_service = get_llm_service()

    def process_query(self, question: str) -> ChatResponse:
        start_time = time.time()
        
        logger.info(f"Processing question: {question}")
        
        question_embedding = self.embedding_service.get_embeddings().embed_query(question)
        
        # We only really care about legal context now, but we keep news query to not break dependencies
        legal_results = self.vector_store.get_legal_collection().query(
            query_embeddings=[question_embedding],
            n_results=settings.TOP_K_LEGAL
        )
        
        legal_context_parts = []
        sources = []
        retrieved_documents = []
        
        if legal_results and legal_results["documents"] and legal_results["documents"][0]:
            for i, (doc, meta, dist) in enumerate(zip(legal_results["documents"][0], legal_results["metadatas"][0], legal_results["distances"][0])):
                legal_context_parts.append(doc)
                sources.append(Source(
                    dataset="legal",
                    title=meta.get("title", "Unknown Title"),
                    document_id=meta.get("document_id")
                ))
                retrieved_documents.append({
                    "dataset": "legal",
                    "content": doc,
                    "metadata": meta,
                    "distance": dist
                })
        
        legal_context = "\n\n".join(legal_context_parts) if legal_context_parts else "No relevant legal information found."
        
        prompt = build_prompt(news_context="", legal_context=legal_context, question=question)
        
        logger.info("Generating answer via LLM...")
        raw_answer = self.llm_service.generate(prompt)
        
        processing_time = time.time() - start_time
        
        min_dist = min([d["distance"] for d in retrieved_documents]) if retrieved_documents else 1.0
        confidence = max(0.0, 1.0 - (min_dist / 2.0))
        
        parsed_data = _parse_llm_json(raw_answer)
        
        return ChatResponse(
            severity=str(parsed_data.get("severity", "Caution")),
            verdict=str(parsed_data.get("verdict", "Unable to provide a clear verdict.")),
            explanation=str(parsed_data.get("explanation", parsed_data.get("answer", raw_answer))),
            laws_cited=parsed_data.get("laws_cited", []),
            case_lens=str(parsed_data.get("case_lens", "N/A")),
            sources=sources,
            confidence=confidence,
            retrieved_documents=retrieved_documents,
            processing_time=processing_time
        )

def get_retriever_service() -> RetrieverService:
    return RetrieverService()
