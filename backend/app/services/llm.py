from langchain_community.llms import Ollama
from app.config import settings
import logging

logger = logging.getLogger(__name__)

class LLMService:
    _instance = None

    @classmethod
    def get_instance(cls):
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        logger.info(f"Initializing LLM with Ollama at {settings.OLLAMA_BASE_URL} (Model: {settings.LLM_MODEL})")
        self.llm = Ollama(
            base_url=settings.OLLAMA_BASE_URL,
            model=settings.LLM_MODEL,
            temperature=0.1
        )

    def generate(self, prompt: str) -> str:
        try:
            return self.llm.invoke(prompt)
        except Exception as e:
            logger.error(f"Error communicating with LLM: {e}")
            raise e

def get_llm_service() -> LLMService:
    return LLMService.get_instance()
