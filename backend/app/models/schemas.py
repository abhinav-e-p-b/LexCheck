from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional

class Source(BaseModel):
    dataset: str
    title: str
    document_id: Optional[str] = None
    url: Optional[str] = None
    date: Optional[str] = None

class ChatRequest(BaseModel):
    question: str = Field(..., description="The user's question regarding Indian news or law.")
    history: Optional[List[Dict[str, str]]] = Field(default_factory=list, description="Optional conversation history.")

class ChatResponse(BaseModel):
    severity: str = Field(..., description="Severity level: Safe, Minor, Caution, Serious, or Criminal")
    verdict: str = Field(..., description="One sentence verdict")
    explanation: str = Field(..., description="Plain English explanation of the legal situation")
    laws_cited: List[str] = Field(..., description="List of relevant laws or sections, e.g. ['IT Act Sec 66E', 'BNS Sec 72']")
    case_lens: str = Field(..., description="A related historical case or example scenario")
    sources: List[Source] = Field(default_factory=list, description="Sources used to answer")
    confidence: float = Field(0.0, description="Confidence score")
    retrieved_documents: List[Dict[str, Any]] = Field(default_factory=list, description="Raw retrieved documents")
    processing_time: float = Field(0.0, description="Time taken to process")

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
