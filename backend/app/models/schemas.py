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

# ---------------------------------------------------------------------------
# Document Risk Scan models
# ---------------------------------------------------------------------------

class RiskFlag(BaseModel):
    clause: str = Field(..., description="The problematic clause or excerpt from the document.")
    reason: str = Field(..., description="Why this clause is risky under Indian law.")
    severity: str = Field(..., description="Risk severity: HIGH, MEDIUM, or LOW.")

class ScanResponse(BaseModel):
    risk_level: str = Field(..., description="Overall risk level: HIGH, MEDIUM, or LOW.")
    flags: List[RiskFlag] = Field(default_factory=list, description="Individual risk flags found.")
    summary: str = Field(..., description="Plain-language summary of the document's risk profile.")
    confidence: float = Field(..., description="Confidence score between 0.0 and 1.0.")
