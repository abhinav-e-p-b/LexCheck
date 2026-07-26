import gradio as gr
from app.main import app as fastapi_app

# Create a dummy Gradio app to satisfy the Hugging Face Gradio SDK
demo = gr.Interface(
    fn=lambda x: x, 
    inputs="text", 
    outputs="text", 
    title="LexCheck Backend Running"
)

# Mount the dummy Gradio app onto our existing FastAPI app
# This allows Hugging Face to host our FastAPI routes (like /scan) natively on the Gradio SDK!
app = gr.mount_gradio_app(fastapi_app, demo, path="/gradio")
