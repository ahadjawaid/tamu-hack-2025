# Handles suno API requests, including GET and POST requests

import time
import requests
import logging
from .suno_api import suno_api_instance, logger

def generate_song(prompt: str, wait_audio=True):
    # Kick off generation
    result = suno_api_instance.generate_song(prompt)
    
    # Extract clip IDs from the initial result
    clip_ids = [clip["id"] for clip in result.get("clips", []) if clip.get("id")]
    if not clip_ids:
        return {"error": "No clip IDs found in generation response."}

    if wait_audio:
        # Poll each clip until we see audio_url or time out
        audio_urls = []
        for cid in clip_ids:
            url = poll_clip(cid)
            if url:
                audio_urls.append(url)
        if not audio_urls:
            return {"error": "All clips timed out; no audio URLs found."}
        else:
            return {"response": result, "audio_urls": audio_urls}
    else:
        return {"response": result, "audio_urls": []}


def poll_clip(clip_id: str, max_attempts=20, wait_time=5) -> str:
    """
    Poll GET /api/clip/<clipId> until 'audio_url' is populated or we time out.
    Returns the final audio_url or None if not found in time.
    """
    session = suno_api_instance.session  # re-use session with cookies
    token = suno_api_instance.current_token  # re-use the current token

    base_url = "https://studio-api.prod.suno.com"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    for attempt in range(max_attempts):
        print(f"Polling clip {clip_id} (Attempt {attempt+1}/{max_attempts})...")
        # If token might expire, do a quick keepAlive or handle 401 on error
        try:
            # fetch
            resp = session.get(f"{base_url}/api/clip/{clip_id}", headers=headers)
            if resp.status_code == 401:
                logger.warning("Got 401. Trying keepAlive then retry once.")
                suno_api_instance.keepAlive()
                headers["Authorization"] = f"Bearer {suno_api_instance.current_token}"
                resp = session.get(f"{base_url}/api/clip/{clip_id}", headers=headers)
            
            resp.raise_for_status()
            data = resp.json()  # e.g. { "id": "...", "audio_url": "", "status": "submitted", ... }
            
            # Check if audio_url is populated
            audio_url = data.get("audio_url", "")
            clip_status = data.get("status")
            if audio_url and clip_status in ["streaming", "complete"]:
                print(f"Clip {clip_id} ready! audio_url={audio_url}")
                return audio_url
            
            print(f"Clip {clip_id} status={clip_status}, audio_url={audio_url or 'empty'}. Waiting {wait_time}s...")
        except requests.HTTPError as ex:
            logger.error(f"Error polling clip {clip_id}: {ex}")
            break

        time.sleep(wait_time)

    print(f"Timed out waiting for clip {clip_id} audio.")
    return None

def save_response_to_file(data, filename: str):
    """
    Save JSON response to a file for debugging
    """
    output_dir = Path("responses")
    output_dir.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filepath = output_dir / f"{timestamp}_{filename}"

    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4)
    print(f"Saved response to {filepath}")
