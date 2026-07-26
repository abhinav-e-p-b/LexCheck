import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "Indian News and Law RAG Backend"
    
    # Paths
    BASE_DIR: str = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    DATA_DIR: str = os.path.join(os.path.dirname(BASE_DIR), "data")
    NEWS_DATA_DIR: str = os.path.join(DATA_DIR, "news")
    LEGAL_DATA_DIR: str = os.path.join(DATA_DIR, "legal")
    DB_DIR: str = os.path.join(BASE_DIR, "db")
    
    # Text Splitting
    CHUNK_SIZE: int = 800
    CHUNK_OVERLAP: int = 150
    
    # Embeddings
    EMBEDDING_MODEL_NAME: str = "BAAI/bge-small-en-v1.5"
    
    # LLM
    OLLAMA_BASE_URL: str = "http://localhost:11434"
    LLM_MODEL: str = "llama3" # Default Ollama model to use, can be changed
    
    # Retrieval
    TOP_K_NEWS: int = 5
    TOP_K_LEGAL: int = 5
    
settings = Settings()
