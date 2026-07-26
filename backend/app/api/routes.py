from fastapi import APIRouter, HTTPException, Depends
from app.models.schemas import ChatRequest, ChatResponse
from app.services.retriever import get_retriever_service, RetrieverService
import logging

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
