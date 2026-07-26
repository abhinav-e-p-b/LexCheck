from fastapi import APIRouter, HTTPException, Depends, UploadFile, File
from app.models.schemas import ChatRequest, ChatResponse, ScanResponse, RiskFlag
from app.services.retriever import get_retriever_service, RetrieverService
from app.services.prompt_builder import build_scan_prompt
from app.services.llm import get_llm_service
import logging
import json
import re
import io

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest, retriever: RetrieverService = Depends(get_retriever_service)):
    if not request.question or not request.question.strip():
        raise HTTPException(status_code=400, detail="Empty query provided.")
    
    try:
        response = retriever.process_query(request.question)
        return response
    except Exception as e:
        logger.error(f"Error processing chat request: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error while processing the request.")


# ---------------------------------------------------------------------------
# Document risk scan endpoint
# ---------------------------------------------------------------------------

def _extract_text(content: bytes, filename: str) -> str:
    """Extract plain text from PDF, DOCX, or TXT bytes."""
    fname = (filename or "").lower()

    if fname.endswith(".pdf"):
        try:
            from pypdf import PdfReader
            reader = PdfReader(io.BytesIO(content))
            return "\n".join(
                (page.extract_text() or "") for page in reader.pages
            ).strip()
        except Exception as e:
            logger.warning(f"pypdf extraction failed: {e}")
            return ""

    if fname.endswith(".docx"):
        try:
            from docx import Document
            doc = Document(io.BytesIO(content))
            return "\n".join(para.text for para in doc.paragraphs).strip()
        except Exception as e:
            logger.warning(f"python-docx extraction failed: {e}")
            return ""

    # Plain text / fallback
    return content.decode("utf-8", errors="ignore").strip()


def _parse_llm_json(raw: str) -> dict:
    """Parse the LLM's response, handling cases where it adds extra text."""
    # 1. Try direct parse
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        pass

    # 2. Strip markdown fences and retry
    cleaned = re.sub(r"```(?:json)?", "", raw).strip()
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError:
        pass

    # 3. Extract the outermost JSON object
    match = re.search(r"\{.*\}", raw, re.DOTALL)
    if match:
        try:
            return json.loads(match.group())
        except json.JSONDecodeError:
            pass

    # 4. Graceful fallback — return the raw text as the summary
    logger.warning("Could not parse JSON from LLM scan response; using fallback.")
    risk_level = "MEDIUM"
    if any(w in raw.lower() for w in ["high risk", "critical", "dangerous"]):
        risk_level = "HIGH"
    elif any(w in raw.lower() for w in ["no risk", "low risk", "minimal"]):
        risk_level = "LOW"

    return {
        "risk_level": risk_level,
        "flags": [],
        "summary": raw[:500].strip(),
        "confidence": 0.5,
    }


@router.post("/scan", response_model=ScanResponse)
async def scan_document(file: UploadFile = File(...)):
    """
    Accept a legal document (PDF / DOCX / TXT) and return a structured
    risk analysis powered by the local Ollama LLM.
    """
    if not file.filename:
        raise HTTPException(status_code=400, detail="No filename provided.")

    content = await file.read()
    if not content:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    # --- Extract text ---
    text = _extract_text(content, file.filename)
    if not text:
        raise HTTPException(
            status_code=422,
            detail="Could not extract text from the document. "
                   "Ensure it is a readable PDF, DOCX, or TXT file.",
        )

    # Limit to ~4 000 chars to stay within LLM context comfortably
    truncated = text[:4000]

    logger.info(f"Scanning '{file.filename}' ({len(truncated)} chars).")

    # --- Build prompt and call LLM ---
    try:
        prompt = build_scan_prompt(truncated)
        llm = get_llm_service()
        raw_response = llm.generate(prompt)
    except Exception as e:
        logger.error(f"LLM error during scan: {e}")
        raise HTTPException(
            status_code=503,
            detail="LLM service unavailable. Make sure Ollama is running.",
        )

    # --- Parse response ---
    data = _parse_llm_json(raw_response)

    flags = [
        RiskFlag(
            clause=str(f.get("clause", ""))[:300],
            reason=str(f.get("reason", ""))[:300],
            severity=str(f.get("severity", "MEDIUM")).upper(),
        )
        for f in data.get("flags", [])
        if isinstance(f, dict)
    ]

    return ScanResponse(
        risk_level=str(data.get("risk_level", "MEDIUM")).upper(),
        flags=flags,
        summary=str(data.get("summary", "Analysis complete."))[:600],
        confidence=float(data.get("confidence", 0.7)),
    )
