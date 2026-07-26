import os
import uvicorn

if __name__ == "__main__":
    # Hardcode port to 8000 to match EXPOSE instruction in Dockerfile
    # This avoids Railway dynamic PORT injection conflicts
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000)
