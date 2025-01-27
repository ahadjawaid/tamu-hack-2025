# Handles suno API requests, including GET and POST requests
import time
import os
import requests
import logging
import json
from pathlib import Path
from datetime import datetime
from aws import upload_file_to_s3
import m3u8
import uuid
import requests
import time
import subprocess
import uuid

from .suno_api import suno_api_instance, logger

def generate_song(prompt: str, wait_audio=True):
    """
    1) Kick off generation via suno_api_instance.generate_song().
    2) Extract each 'clip_id' from the result.
    3) If wait_audio=True, poll each clip until we see 'audio_url'.
    4) Download each audio file, and return final data.
    """
    # 1) Start generation
    print("Generate_song prompt", prompt)
    result = suno_api_instance.generate_song(prompt)
    print("Generate_song result", result)
    # 2) Optionally save raw JSON for debugging
    save_response_to_file(result, "response.json")
    print("save response")

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

def get_unique_string():
    return str(uuid.uuid4())


def download_audio_files(audio_urls, output_dir="downloaded_audio"):
    """
    1) Download each .mp4 audio from 'audio_urls'.
    2) Convert to HLS .m3u8 using ffmpeg.
    3) Upload .m3u8 + segments to S3.
    4) Return a list of final .m3u8 S3 URLs for playback.
    """
    os.makedirs(output_dir, exist_ok=True)
    final_m3u8_urls = []

    for i, url in enumerate(audio_urls, start=1):
        # Step A: Download the .mp4 file
        local_mp4 = os.path.join(output_dir, f"song_{i}.mp4")
        print(f"Downloading {url} -> {local_mp4}")
        with requests.get(url, stream=True) as resp:
            resp.raise_for_status()
            with open(local_mp4, "wb") as f:
                for chunk in resp.iter_content(8192):
                    if chunk:
                        f.write(chunk)
        print(f"Saved: {local_mp4}")

        # Step B: Convert to HLS .m3u8 + .ts segments via ffmpeg
        # Put HLS output in a subfolder so each file is isolated
        hls_folder = os.path.join(output_dir, f"hls_{i}")
        os.makedirs(hls_folder, exist_ok=True)

        hls_playlist = os.path.join(hls_folder, "playlist.m3u8")
        # Example ffmpeg command:
        #   ffmpeg -y -i input.mp4 -c:a aac -b:a 128k -ac 2 -hls_list_size 0 -hls_time 4 -f hls playlist.m3u8
        cmd = [
            "ffmpeg",
            "-y",
            "-i", local_mp4,
            "-c:a", "aac",
            "-b:a", "128k",
            "-ac", "2",
            "-hls_list_size", "0",   # full VOD playlist
            "-hls_time", "4",
            "-f", "hls",
            hls_playlist
        ]
        subprocess.run(cmd, check=True)
        print(f"Created HLS in {hls_folder}")

        # Step C: Upload .m3u8 + .ts segments to S3, rewriting the local .m3u8 to use S3 URLs
        final_url = upload_m3u8_and_segments_to_s3(hls_playlist)
        final_m3u8_urls.append(final_url)
        print(f"HLS URL -> {final_url}")

    return final_m3u8_urls


def upload_m3u8_and_segments_to_s3(m3u8_path, bucket_name="brainbeats1"):
    """
    1) Parse .m3u8, find any .ts (or .aac) segment references.
    2) Upload each segment to S3 with a unique key.
    3) Rewrite lines in .m3u8 to point to the S3 segment URLs.
    4) Upload the final .m3u8 to S3 and return its URL.
    """
    import re

    folder = os.path.dirname(m3u8_path)
    with open(m3u8_path, "r") as f:
        lines = f.readlines()

    segment_pattern = re.compile(r'^(?!#)(.*\.(ts|aac|m4s|mp4))$', re.IGNORECASE)
    s3_urls_map = {}  # local segment filename -> S3 URL

    # 1) For each segment reference line, upload to S3
    for i, line in enumerate(lines):
        seg_match = segment_pattern.match(line.strip())
        if seg_match:
            seg_name = seg_match.group(1)  # e.g. "playlist0.ts"
            local_seg_path = os.path.join(folder, seg_name)
            # Upload to S3
            s3_key = f"{get_unique_string()}/{seg_name}"
            s3_url = upload_file_to_s3(bucket_name, local_seg_path, s3_key)
            s3_urls_map[seg_name] = s3_url

    # 2) Rewrite lines in memory
    new_lines = []
    for line in lines:
        seg_match = segment_pattern.match(line.strip())
        if seg_match:
            seg_name = seg_match.group(1)
            new_lines.append(s3_urls_map[seg_name] + "\n")
        else:
            new_lines.append(line)

    # 3) Write out a "remote" .m3u8 that references S3 segments
    final_m3u8_path = os.path.join(folder, "playlist_remote.m3u8")
    with open(final_m3u8_path, "w") as out:
        out.writelines(new_lines)

    # 4) Upload that new .m3u8 to S3
    final_m3u8_key = f"{get_unique_string()}/playlist.m3u8"
    final_s3_m3u8_url = upload_file_to_s3(bucket_name, final_m3u8_path, final_m3u8_key)

    return final_s3_m3u8_url


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