import os
import pandas as pd
import json
import uuid
import logging
from langchain.text_splitter import RecursiveCharacterTextSplitter
from app.config import settings
from app.services.embedding import get_embedding_service
from app.services.vector_store import get_vector_store_manager

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def ingest_data():
    logger.info("Starting data ingestion process...")
    
    embedding_service = get_embedding_service()
    vector_store = get_vector_store_manager()
    embeddings_model = embedding_service.get_embeddings()
    
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=settings.CHUNK_SIZE,
        chunk_overlap=settings.CHUNK_OVERLAP,
    )
    
    # 1. Ingest News Dataset
    news_csv_path = os.path.join(settings.NEWS_DATA_DIR, "india-news-headlines.csv")
    if os.path.exists(news_csv_path):
        logger.info(f"Loading news from {news_csv_path}")
        df_news = pd.read_csv(news_csv_path)
        df_news.dropna(inplace=True)
        # Take a subset if it's too large for a simple run, or ingest all
        # To avoid massive ingest times for this task, let's limit it unless needed
        # df_news = df_news.head(1000) # Optional limit
        
        texts = []
        metadatas = []
        ids = []
        
        for idx, row in df_news.iterrows():
            date = str(row.get('publish_date', ''))
            category = str(row.get('headline_category', ''))
            headline = str(row.get('headline_text', ''))
            
            content = f"Date: {date}\nCategory: {category}\nHeadline: {headline}"
            chunks = text_splitter.split_text(content)
            
            for chunk in chunks:
                doc_id = str(uuid.uuid4())
                texts.append(chunk)
                metadatas.append({
                    "dataset": "news",
                    "title": headline,
                    "date": date,
                    "section": category,
                    "document_id": doc_id,
                    "source": "india-news-headlines"
                })
                ids.append(doc_id)
                
            # Batch add to avoid memory issues
            if len(texts) >= 500:
                logger.info("Adding batch to News Collection...")
                vector_store.get_news_collection().add(
                    documents=texts,
                    metadatas=metadatas,
                    ids=ids,
                )
                texts, metadatas, ids = [], [], []
                
        # Add remaining
        if texts:
            vector_store.get_news_collection().add(documents=texts, metadatas=metadatas, ids=ids)
            logger.info("Added final batch to News Collection.")
    else:
        logger.warning(f"News dataset not found at {news_csv_path}")
        
    # 2. Ingest Legal Dataset
    legal_files = ["constitution_qa.json", "crpc_qa.json", "ipc_qa.json"]
    texts = []
    metadatas = []
    ids = []
    
    for file_name in legal_files:
        legal_file_path = os.path.join(settings.LEGAL_DATA_DIR, file_name)
        if os.path.exists(legal_file_path):
            logger.info(f"Loading legal text from {legal_file_path}")
            with open(legal_file_path, 'r', encoding='utf-8') as f:
                try:
                    data = json.load(f)
                    # format might be a list of objects or a single dict
                    if not isinstance(data, list):
                        data = [data]
                        
                    for item in data:
                        title = item.get("question", item.get("title", file_name))
                        body = item.get("answer", item.get("text", str(item)))
                        content = f"Title: {title}\nContent: {body}"
                        
                        chunks = text_splitter.split_text(content)
                        for chunk in chunks:
                            doc_id = str(uuid.uuid4())
                            texts.append(chunk)
                            metadatas.append({
                                "dataset": "legal",
                                "title": title,
                                "document_id": doc_id,
                                "source": file_name
                            })
                            ids.append(doc_id)
                            
                        if len(texts) >= 500:
                            logger.info("Adding batch to Legal Collection...")
                            vector_store.get_legal_collection().add(
                                documents=texts,
                                metadatas=metadatas,
                                ids=ids
                            )
                            texts, metadatas, ids = [], [], []
                except Exception as e:
                    logger.error(f"Failed to parse {legal_file_path}: {e}")
        else:
            logger.warning(f"Legal dataset not found at {legal_file_path}")
            
    # Add remaining
    if texts:
        vector_store.get_legal_collection().add(documents=texts, metadatas=metadatas, ids=ids)
        logger.info("Added final batch to Legal Collection.")

    logger.info("Data ingestion completed successfully.")

if __name__ == "__main__":
    ingest_data()
