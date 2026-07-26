# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create the chroma DB directory and give permissions
RUN mkdir -p /app/db && chmod 777 /app/db

# Copy the rest of the backend code
COPY . .

# Set environment variables for caching and permissions
ENV PYTHONUNBUFFERED=1
ENV TRANSFORMERS_CACHE=/tmp/transformers_cache
RUN mkdir -p /tmp/transformers_cache && chmod 777 /tmp/transformers_cache

# Expose port 7860 (Hugging Face Spaces default)
EXPOSE 7860

# Run FastAPI app with Uvicorn on port 7860
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7860"]
