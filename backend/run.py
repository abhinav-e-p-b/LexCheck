import os
import uvicorn

if __name__ == "__main__":
    # Railway provides the port via the PORT environment variable.
    # We default to 8000 for local development.
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app.main:app", host="0.0.0.0", port=port)
