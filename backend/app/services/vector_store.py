import chromadb
from app.config import settings
import logging

logger = logging.getLogger(__name__)

class VectorStoreManager:
    _instance = None

    @classmethod
    def get_instance(cls):
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        logger.info(f"Initializing ChromaDB client at {settings.DB_DIR}")
        self.client = chromadb.PersistentClient(path=settings.DB_DIR)
        
        # We ensure both collections exist
        self.news_collection = self.client.get_or_create_collection(name="news_collection")
        self.legal_collection = self.client.get_or_create_collection(name="legal_collection")
        logger.info("ChromaDB collections loaded successfully.")

    def get_news_collection(self):
        return self.news_collection

    def get_legal_collection(self):
        return self.legal_collection

def get_vector_store_manager() -> VectorStoreManager:
    return VectorStoreManager.get_instance()
