---
title: LexCheck Backend
emoji: 🚀
colorFrom: blue
colorTo: indigo
sdk: gradio
sdk_version: 4.36.1
app_file: app.py
pinned: false
---

# Indian News and Law RAG Backend

This is the backend for the RAG system integrating Indian News and Legal datasets.

## Requirements

- Python 3.11+
- Ollama (installed locally and running `llama3` or desired model)

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Ensure the datasets are placed in `../data/news` and `../data/legal` relative to the backend directory.

3. Run the ingestion pipeline to index datasets into ChromaDB:
```bash
python -m app.ingest
```

4. Start the FastAPI server:
```bash
python -m app.main
```
or 
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## Flutter Integration Example

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendChatRequest(String question) async {
  final url = Uri.parse('http://10.0.2.2:8000/chat'); // Android Emulator localhost
  
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'question': question}),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Answer: ${data['answer']}');
    print('Sources: ${data['sources']}');
  } else {
    print('Failed to get response');
  }
}
```

## Architecture

- **FastAPI**: API endpoints
- **LangChain**: Orchestration and text splitting
- **ChromaDB**: Vector Database (using `news_collection` and `legal_collection`)
- **SentenceTransformers**: `BAAI/bge-small-en-v1.5` for embeddings
- **Ollama**: Local LLM backend
