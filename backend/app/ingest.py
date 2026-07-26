import os
import pandas as pd
import json
import uuid
import logging
from langchain_text_splitters import RecursiveCharacterTextSplitter
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
    
    texts = []
    metadatas = []
    ids = []
    
    # 1. Load BNS IPC Comparative CSV to map old sections
    comparative_path = os.path.join(settings.LEGAL_DATA_DIR, "BNS_IPC_Comparative.csv")
    bns_to_ipc_map = {}
    if os.path.exists(comparative_path):
        logger.info(f"Loading comparative mapping from {comparative_path}")
        try:
            df = pd.read_csv(comparative_path)
            for idx, row in df.iterrows():
                bns_sec = str(row.get('BNS_Section', ''))
                ipc_sec = str(row.get('IPC_Section', ''))
                if pd.notna(bns_sec) and pd.notna(ipc_sec) and bns_sec and ipc_sec:
                    # Map section number, e.g., "1(1)" -> "1"
                    base_bns = bns_sec.split('(')[0].strip()
                    if base_bns not in bns_to_ipc_map:
                        bns_to_ipc_map[base_bns] = ipc_sec
        except Exception as e:
            logger.error(f"Error parsing comparative CSV: {e}")
            
    # 2. Ingest BNS JSON
    bns_path = os.path.join(settings.LEGAL_DATA_DIR, "bns_all_section.json")
    if os.path.exists(bns_path):
        logger.info(f"Loading BNS data from {bns_path}")
        with open(bns_path, 'r', encoding='utf-8') as f:
            try:
                bns_data = json.load(f)
                for item in bns_data:
                    section_no = str(item.get("section_no", ""))
                    title = item.get("title", "")
                    body = item.get("body", "")
                    chapter = item.get("chapter", "")
                    
                    ipc_equiv = bns_to_ipc_map.get(section_no, "N/A")
                    
                    content = f"Act: Bharatiya Nyaya Sanhita (BNS)\nChapter: {chapter}\nSection: {section_no}\nTitle: {title}\nOld IPC Equivalent: Section {ipc_equiv}\n\nContent: {body}"
                    
                    chunks = text_splitter.split_text(content)
                    for chunk in chunks:
                        doc_id = str(uuid.uuid4())
                        texts.append(chunk)
                        metadatas.append({
                            "dataset": "legal",
                            "act": "BNS",
                            "section": section_no,
                            "title": title,
                            "ipc_equivalent": ipc_equiv,
                            "document_id": doc_id,
                            "source": "bns_all_section"
                        })
                        ids.append(doc_id)
                        
                    if len(texts) >= 500:
                        logger.info("Adding batch to Legal Collection...")
                        vector_store.get_legal_collection().add(documents=texts, metadatas=metadatas, ids=ids)
                        texts, metadatas, ids = [], [], []
            except Exception as e:
                logger.error(f"Failed to parse BNS JSON: {e}")
                
    # 3. Ingest IT Act JSON
    it_act_path = os.path.join(settings.LEGAL_DATA_DIR, "it_act_sections.json")
    if os.path.exists(it_act_path):
        logger.info(f"Loading IT Act data from {it_act_path}")
        with open(it_act_path, 'r', encoding='utf-8') as f:
            try:
                it_data = json.load(f)
                sections = it_data.get("sections", [])
                for item in sections:
                    section_no = str(item.get("section", ""))
                    title = item.get("title", "")
                    summary = item.get("summary", "")
                    penalty = item.get("penalty", "")
                    
                    content = f"Act: Information Technology (IT) Act, 2000\nSection: {section_no}\nTitle: {title}\nSummary: {summary}\nPenalty: {penalty}"
                    
                    chunks = text_splitter.split_text(content)
                    for chunk in chunks:
                        doc_id = str(uuid.uuid4())
                        texts.append(chunk)
                        metadatas.append({
                            "dataset": "legal",
                            "act": "IT Act",
                            "section": section_no,
                            "title": title,
                            "document_id": doc_id,
                            "source": "it_act_sections"
                        })
                        ids.append(doc_id)
                        
                    if len(texts) >= 500:
                        logger.info("Adding batch to Legal Collection...")
                        vector_store.get_legal_collection().add(documents=texts, metadatas=metadatas, ids=ids)
                        texts, metadatas, ids = [], [], []
            except Exception as e:
                logger.error(f"Failed to parse IT Act JSON: {e}")
                
    # Add remaining legal
    if texts:
        vector_store.get_legal_collection().add(documents=texts, metadatas=metadatas, ids=ids)
        logger.info("Added final batch to Legal Collection.")
        
    logger.info("Data ingestion completed successfully.")

if __name__ == "__main__":
    ingest_data()
