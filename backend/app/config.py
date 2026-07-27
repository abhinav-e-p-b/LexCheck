import os
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8"
    )

    APP_NAME: str = "Indian News and Law RAG Backend"

    BASE_DIR: str = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    DATA_DIR: str = os.path.join(os.path.dirname(BASE_DIR), "data")
    NEWS_DATA_DIR: str = os.path.join(DATA_DIR, "news")
    LEGAL_DATA_DIR: str = os.path.join(DATA_DIR, "legal")
    DB_DIR: str = os.path.join(BASE_DIR, "db")

    CHUNK_SIZE: int = 800
    CHUNK_OVERLAP: int = 150

    EMBEDDING_MODEL_NAME: str = "BAAI/bge-small-en-v1.5"

    # Read from .env
    GROQ_API_KEY: str

    LLM_MODEL: str = "llama-3.1-8b-instant"

    TOP_K_NEWS: int = 5
    TOP_K_LEGAL: int = 5

settings = Settings()