from langchain_groq import ChatGroq
from app.config import settings
import logging
import os

logger = logging.getLogger(__name__)

class LLMService:
    _instance = None

    @classmethod
    def get_instance(cls):
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        api_key = settings.GROQ_API_KEY or os.environ.get("GROQ_API_KEY")
        if not api_key:
            raise ValueError("GROQ_API_KEY is missing. Please set it in config.py or environment variables.")
        
        logger.info(f"Initializing LLM with Groq (Model: {settings.LLM_MODEL})")
        self.llm = ChatGroq(
            api_key=api_key,
            model_name=settings.LLM_MODEL,
            temperature=0.1
        )

    def generate(self, prompt: str) -> str:
        try:
            response = self.llm.invoke(prompt)
            if hasattr(response, 'content'):
                return response.content
            return str(response)
        except Exception as e:
            logger.error(f"Error communicating with LLM: {e}")
            raise e

def get_llm_service() -> LLMService:
    return LLMService.get_instance()
