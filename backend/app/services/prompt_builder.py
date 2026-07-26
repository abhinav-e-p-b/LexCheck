from langchain.prompts import PromptTemplate

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
