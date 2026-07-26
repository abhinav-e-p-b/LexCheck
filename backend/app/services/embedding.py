from langchain_huggingface import HuggingFaceEmbeddings
from app.config import settings
import logging

logger = logging.getLogger(__name__)

class EmbeddingService:
    _instance = None

    @classmethod
    def get_instance(cls):
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        logger.info(f"Initializing Embedding Model: {settings.EMBEDDING_MODEL_NAME}")
        self.embeddings = HuggingFaceEmbeddings(model_name=settings.EMBEDDING_MODEL_NAME)
        logger.info("Embedding Model loaded successfully.")

    def get_embeddings(self):
        return self.embeddings

# Singleton instance access
def get_embedding_service() -> EmbeddingService:
    return EmbeddingService.get_instance()
