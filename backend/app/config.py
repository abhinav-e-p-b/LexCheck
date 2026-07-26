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
    
    # LLM — Groq (free at console.groq.com)
    GROQ_API_KEY: str = ""  # Paste your key here OR set env var GROQ_API_KEY
    LLM_MODEL: str = "llama-3.1-8b-instant"  # Fast free model; alternatives: llama3-70b-8192, mixtral-8x7b-32768
    
    # Retrieval
    TOP_K_NEWS: int = 5
    TOP_K_LEGAL: int = 5
    
settings = Settings()
