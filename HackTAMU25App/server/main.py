# Entry point to initialize API calls

import uvicorn
import uuid
from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from api.client import generate_song, generate_lyrics, generate_songs_and_lyrics

app = FastAPI()
app.mount("/audio", StaticFiles(directory="downloaded_audio"), name="audio")
SONG_DATA = []

class SongPrompt(BaseModel):
    prompt: str

@app.post("/generate")
def generate_song_endpoint(song_prompt: SongPrompt):
    """
    Expects JSON Body (example): {"prompt": "Upbeat pop song about adult budgeting"}
    (Receives POST from mobile app or call suno API using a session cookie)
    
    """
    try:
        # You can set wait_audio=True or False based on desired behavior
        result = generate_song(song_prompt.prompt, wait_audio=True)
        if "error" in result:
            raise HTTPException(status_code=400, detail=result["error"])
        return {"response": result}
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

class LyricsPrompt(BaseModel):
    prompt: str
    
@app.post("/generate_lyrics")
def generate_lyrics_endpoint(lyrics_prompt: LyricsPrompt):
    """
    Expects JSON Body (example): {"prompt": "Upbeat pop song about adult budgeting"}
    (Receives POST from mobile app or call suno API using a session cookie)
    
    """
    try:
        result = generate_lyrics(lyrics_prompt.prompt)
        
        # Final JSON response format
        return result
        
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

class CombinedPrompt(BaseModel):
    prompt: str

@app.post("/generate_both")
def generate_song_and_lyric_endpoint(payload: CombinedPrompt):
    """
    Single endpoint to generate BOTH audio and lyrics from the same prompt.
    Example POST JSON: {"prompt": "A soothing lullaby"}
    Returns {
      "audio": { ... same structure as /generate ... },
      "lyrics": { "text": "...", "title": "...", "status": "complete" }
    }
    """
    try:
        result = generate_songs_and_lyrics(payload.prompt, wait_audio=True)
        if "error" in result:
            raise HTTPException(status_code=400, detail=result["error"])
        song_id = str(uuid.uuid4())
        audio_data = result.get("audio", {})
        lyrics_data = result.get("lyrics", {})
        
        stored_info = {
            "song_id": song_id,
            "title": lyrics_data.get("title", "Untitled"),
            "lyrics": lyrics_data.get("text", ""),
            "audio_file": audio_data.get("downloaded_files", []),
            "audio_url": audio_data.get("audio_url", [])
        }
        
        SONG_DATA.append(stored_info)
        return {
            "response": {
                **result,
                "song_id": song_id
            }
        }
    
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
    