# Entry point to initialize API calls

import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from api.client import generate_song
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/downloaded_audio/{filename}")
async def serve_audio(filename: str):
    return FileResponse(
        f"downloaded_audio/{filename}",
        media_type="video/mp4",
        headers={
            "Accept-Ranges": "bytes"
        }
    )


class SongPrompt(BaseModel):
    prompt: str

@app.post("/generate")
def generate_song_endpoint(song_prompt: SongPrompt):
    """
    Expects JSON Body (example): {"prompt": "Upbeat pop song about adult budgeting"}
    (Receives POST from mobile app or call suno API using a session cookie)
    
    """
    print("Called", "song_prompt", song_prompt)
    try:
        # You can set wait_audio=True or False based on desired behavior
        print("Enter generate_song")
        result = generate_song(song_prompt.prompt, wait_audio=True)
        print("Got result", result)
        if "error" in result:
            raise HTTPException(status_code=400, detail=result["error"])
        return {"response": result}
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
def health_check():
    # Simple GET endpoint to check if the server is running
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
    