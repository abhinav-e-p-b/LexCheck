from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional

class ChatRequest(BaseModel):
    question: str = Field(..., description="The user's question regarding Indian news or law.")
    history: Optional[List[Dict[str, str]]] = Field(default_factory=list, description="Optional conversation history.")

class Source(BaseModel):
    dataset: str
    title: str
    document_id: Optional[str] = None
    url: Optional[str] = None
    date: Optional[str] = None

class ChatResponse(BaseModel):
    answer: str
    sources: List[Source]
    confidence: float
    retrieved_documents: List[Dict[str, Any]]
    processing_time: float
