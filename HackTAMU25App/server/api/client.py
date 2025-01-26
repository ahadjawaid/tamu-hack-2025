# Handles suno API requests, including GET and POST requests
import time
import os
import requests
import logging
import json
from pathlib import Path
from datetime import datetime

from .suno_api import suno_api_instance, logger

def generate_song(prompt: str, wait_audio=True):
    """
    1) Kick off generation via suno_api_instance.generate_song().
    2) Extract each 'clip_id' from the result.
    3) If wait_audio=True, poll each clip until we see 'audio_url'.
    4) Download each audio file, and return final data.
    """
    # 1) Start generation
    result = suno_api_instance.generate_song(prompt)

    # 2) Optionally save raw JSON for debugging
    save_response_to_file(result, "response.json")

    # The result typically looks like:
    # {
    #   "id": "...",
    #   "clips": [
    #     {"id": "clip1-uuid", "audio_url": "", "status": "submitted", ...},
    #     ...
    #   ]
    # }
    clips = result.get("clips", [])
    clip_ids = [c["id"] for c in clips if c.get("id")]

    if not clip_ids:
        return {"error": "No clip IDs found in generation response."}

    if wait_audio:
        # 3) Poll each clip
        audio_urls = []
        for cid in clip_ids:
            final_url = poll_clip(cid)
            if final_url:
                audio_urls.append(final_url)

        if not audio_urls:
            return {"error": "All clips timed out; no audio URLs found."}
        else:
            # 4) Download each file to local .mp4
            downloaded_files = download_audio_files(audio_urls, "downloaded_audio")
            return {
                "response": result,
                "audio_urls": audio_urls,
                "downloaded_files": downloaded_files
            }
    else:
        # If not waiting, just return what we have (likely empty audio_url)
        return {"response": result, "audio_urls": []}

def generate_lyrics(prompt: str) -> dict:
    """
    Calls suno_api_instance.generate_lyrics(prompt) 
    """
    return suno_api_instance.generate_lyrics(prompt)


def poll_clip(clip_id: str, max_attempts=20, wait_time=5):
    """
    Polls GET /api/clip/{clip_id} until 'audio_url' is populated or we time out.
    Returns the final 'audio_url' or None.
    """
    base_url = "https://studio-api.prod.suno.com"
    session = suno_api_instance.session
    token = suno_api_instance.current_token

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    for attempt in range(max_attempts):
        print(f"Polling clip {clip_id} (Attempt {attempt+1}/{max_attempts})...")

        try:
            resp = session.get(f"{base_url}/api/clip/{clip_id}", headers=headers)

            # If token might have expired mid-poll, do a keepAlive + retry
            if resp.status_code == 401:
                logger.warning("Got 401 unauthorized. Attempting keepAlive + one retry.")
                suno_api_instance.keepAlive()
                headers["Authorization"] = f"Bearer {suno_api_instance.current_token}"
                resp = session.get(f"{base_url}/api/clip/{clip_id}", headers=headers)

            resp.raise_for_status()
            data = resp.json()  # e.g. { "id": clip_id, "audio_url": "", "status": "submitted", ... }

            clip_status = data.get("status")
            audio_url = data.get("audio_url", "")

            if audio_url and clip_status in ["streaming", "complete"]:
                print(f"Clip {clip_id} ready -> audio_url={audio_url}")
                return audio_url
            else:
                print(f"Clip {clip_id} status={clip_status}, audio_url={'empty' if not audio_url else audio_url}.")
        except requests.HTTPError as e:
            logger.error(f"Error polling clip {clip_id}: {e}")
            return None

        time.sleep(wait_time)

    print(f"Timed out waiting for clip {clip_id} to have audio.")
    return None


def download_audio_files(audio_urls, output_dir="downloaded_audio"):
    """
    Given a list of 'audio_urls', downloads each as .mp4 into 'output_dir'.
    Returns a list of local file paths.
    """
    os.makedirs(output_dir, exist_ok=True)
    saved_paths = []

    for i, url in enumerate(audio_urls, start=1):
        filename = f"song_{i}.mp4"  # or detect extension from headers
        filepath = os.path.join(output_dir, filename)

        print(f"Downloading {url} -> {filepath}")
        resp = requests.get(url, stream=True)
        resp.raise_for_status()

        with open(filepath, "wb") as f:
            for chunk in resp.iter_content(8192):
                if chunk:
                    f.write(chunk)

        print(f"Saved: {filepath}")
        saved_paths.append(filepath)

    return saved_paths


def save_response_to_file(data, filename: str):
    """
    Saves the 'data' JSON into a 'responses/' folder for debugging.
    """
    output_dir = Path("responses")
    output_dir.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    path = output_dir / f"{timestamp}_{filename}"

    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4)

    print(f"Saved response to {path}")