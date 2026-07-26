from langchain_core.prompts import PromptTemplate

SYSTEM_PROMPT = """You are an expert assistant specializing in Indian News and Indian Law.
You have access to two knowledge sources:
1. India News Headlines
2. Indian Legal Texts

Rules:
- Never invent facts.
- Only use retrieved context.
- If information exists in both datasets, combine them.
- If only one dataset contains relevant information, ignore the other.
- Explain legal implications.
- Mention Acts or Sections whenever available.
- If information is insufficient, state that clearly.

End every answer with "Sources:" followed by the retrieved documents.
"""

USER_PROMPT_TEMPLATE = """Context
News
{news_context}
--------------------------------
Legal
{legal_context}
--------------------------------
Question
{question}

Instructions
Produce a detailed answer.
Summarize information.
Explain legal implications.
Mention relevant sections.
Mention related acts.
Mention penalties if available.
Do not hallucinate."""

def build_prompt(news_context: str, legal_context: str, question: str) -> str:
    template = PromptTemplate(
        template=USER_PROMPT_TEMPLATE,
        input_variables=["news_context", "legal_context", "question"]
    )
    user_prompt = template.format(
        news_context=news_context,
        legal_context=legal_context,
        question=question
    )
    return f"{SYSTEM_PROMPT}\n\n{user_prompt}"

# ---------------------------------------------------------------------------
# Document risk scan prompt
# ---------------------------------------------------------------------------

SCAN_PROMPT_TEMPLATE = """You are a senior legal risk analyst specializing in Indian contract law and the Indian legal system.
Analyze the legal document provided below. Identify clauses that expose the user to legal or financial risk.

CRITICAL INSTRUCTION: Return ONLY a valid JSON object. No preamble, no explanation, no markdown code fences.

Required JSON structure:
{{
  "risk_level": "HIGH" | "MEDIUM" | "LOW",
  "flags": [
    {{
      "clause": "brief verbatim quote or paraphrase of the problematic clause",
      "reason": "concise explanation of why this clause is risky under Indian law",
      "severity": "HIGH" | "MEDIUM" | "LOW"
    }}
  ],
  "summary": "2-3 sentence plain-English summary of overall risk",
  "confidence": <float between 0.0 and 1.0>
}}

Risk patterns to check:
- Uncapped or unlimited liability clauses
- One-sided termination rights without notice
- Non-compete or non-solicitation clauses that are overly broad (ICA 1872 / NDA considerations)
- Jurisdiction in a foreign or disadvantageous court
- Auto-renewal traps with minimal notice periods
- Intellectual property assignment without compensation
- Indemnification clauses heavily skewed against one party
- Penalty clauses disproportionate to breach (Indian Contract Act §74 considerations)
- Vague or missing dispute resolution mechanisms
- Missing payment protection or delayed payment penalty provisions

If the document has no identifiable risk, return risk_level "LOW" and an empty flags array.

Document to analyze:
{document_text}"""

def build_scan_prompt(document_text: str) -> str:
    """Build a prompt that instructs the LLM to return a JSON risk analysis."""
    return SCAN_PROMPT_TEMPLATE.format(document_text=document_text)

