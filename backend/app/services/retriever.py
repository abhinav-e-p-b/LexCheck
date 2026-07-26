import time
import logging
from typing import Dict, Any
from app.config import settings
from app.services.embedding import get_embedding_service
from app.services.vector_store import get_vector_store_manager
from app.services.llm import get_llm_service
from app.services.prompt_builder import build_prompt
from app.models.schemas import ChatResponse, Source

logger = logging.getLogger(__name__)

class RetrieverService:
    def __init__(self):
        self.embedding_service = get_embedding_service()
        self.vector_store = get_vector_store_manager()
        self.llm_service = get_llm_service()

    def process_query(self, question: str) -> ChatResponse:
        start_time = time.time()
        
        logger.info(f"Processing question: {question}")
        
        # Generate embedding for the question
        question_embedding = self.embedding_service.get_embeddings().embed_query(question)
        
        # Query News Collection
        news_results = self.vector_store.get_news_collection().query(
            query_embeddings=[question_embedding],
            n_results=settings.TOP_K_NEWS
        )
        
        # Query Legal Collection
        legal_results = self.vector_store.get_legal_collection().query(
            query_embeddings=[question_embedding],
            n_results=settings.TOP_K_LEGAL
        )
        
        # Extract and format context
        news_context_parts = []
        legal_context_parts = []
        sources = []
        retrieved_documents = []
        
        # Process News
        if news_results and news_results["documents"] and news_results["documents"][0]:
            for i, (doc, meta, dist) in enumerate(zip(news_results["documents"][0], news_results["metadatas"][0], news_results["distances"][0])):
                # We can use dist to filter bad results, but we will keep top K for now
                news_context_parts.append(doc)
                sources.append(Source(
                    dataset="news",
                    title=meta.get("title", "Unknown Title"),
                    document_id=meta.get("document_id"),
                    date=meta.get("date")
                ))
                retrieved_documents.append({
                    "dataset": "news",
                    "content": doc,
                    "metadata": meta,
                    "distance": dist
                })
                
        # Process Legal
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
        
        news_context = "\n\n".join(news_context_parts) if news_context_parts else "No relevant news found."
        legal_context = "\n\n".join(legal_context_parts) if legal_context_parts else "No relevant legal information found."
        
        # Build prompt
        prompt = build_prompt(news_context, legal_context, question)
        
        # Generate Answer
        logger.info("Generating answer via LLM...")
        answer = self.llm_service.generate(prompt)
        
        processing_time = time.time() - start_time
        
        # Simplified confidence score based on minimum distance (distance is smaller for closer matches)
        # Using a dummy logic to just output something since chroma distances vary
        min_dist = min([d["distance"] for d in retrieved_documents]) if retrieved_documents else 1.0
        confidence = max(0.0, 1.0 - (min_dist / 2.0)) # heuristic confidence
        
        return ChatResponse(
            answer=answer,
            sources=sources,
            confidence=confidence,
            retrieved_documents=retrieved_documents,
            processing_time=processing_time
        )

def get_retriever_service() -> RetrieverService:
    return RetrieverService()
