# Handles Clerk handshake by using fresh cookies and discovering session ID along with adding JWT for authorization
import os
import time
import json
import requests
import logging
from decouple import config

logging.basicConfig(
    level=logging.DEBUG,  # Changed from INFO to DEBUG
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler("suno_api.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class SunoApiPython:
    BASE_URL = "https://studio-api.prod.suno.com"
    CLERK_URL = "https://clerk.suno.com"
    CLERK_VERSION = "5.34.0"

    def __init__(self, suno_cookie: str):
        self.suno_cookie = suno_cookie
        self.sid = None            # Session ID from Clerk
        self.current_token = None  # Fresh JWT from Clerk

        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": (
                "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 "
                "Mobile Safari/537.36"
            ),
            "Cookie": suno_cookie,
        })

    def init(self):
        logger.info("Initializing suno API...")
        self.getAuthToken()
        self.keepAlive()
        logger.info("Initialization complete.")

    def getAuthToken(self):
        url = f"{self.CLERK_URL}/v1/client?_clerk_js_version={self.CLERK_VERSION}"
        logger.info(f"Getting session ID from Clerk: {url}")
        try:
            resp = self.session.get(url)
            logger.debug(f"Clerk GET Response: {resp.status_code} {resp.text}")
            resp.raise_for_status()
            data = resp.json()

            if "response" not in data or "last_active_session_id" not in data["response"]:
                logger.error("Failed to get session ID from Clerk.")
                raise Exception("Failed to get session ID from Clerk. Check if cookie is correct.")

            self.sid = data["response"]["last_active_session_id"]
            logger.info(f"Session ID: {self.sid}")

        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to get session ID from Clerk: {e}")
            raise Exception("Check if cookie is correct.")

    def keepAlive(self):
        """
        POST /v1/client/sessions/{sid}/tokens?__clerk_js_version=CLERK_VERSION
        to get a fresh JWT and store in self.current_token
        """
        if not self.sid:
            logger.error("No session ID set, can't keepAlive.")
            raise Exception("No session ID set, can't keepAlive.")
        url = f"{self.CLERK_URL}/v1/client/sessions/{self.sid}/tokens?_clerk_js_version={self.CLERK_VERSION}"
        logger.info(f"Renewing JWT token from Clerk: {url}")

        try:
            resp = self.session.post(url)
            logger.debug(f"Clerk POST Response: {resp.status_code} {resp.text}")
            resp.raise_for_status()
            data = resp.json()

            if "jwt" not in data:
                logger.error("Failed to get fresh JWT from Clerk.")
                raise Exception("Failed to get fresh JWT from Clerk. Check your cookie.")

            self.current_token = data["jwt"]
            logger.info("JWT token renewed.")

        except requests.exceptions.RequestException as e:
            logger.error(f"Request to Clerk for token renewal failed: {e}")
            raise

    def generate_song(self, prompt: str, make_instrumental=False,
                      model="chirp-v3", wait_audio=True) -> dict:
        """
        Kick off generation at /api/generate/v2/.
        This returns immediately with an 'id' and some clips with empty audio_url.
        """
        try:
            self.keepAlive()
            payload = {
                "prompt": prompt,
                "gpt_description_prompt": prompt,
                "generation_type": "AUDIO",
                "make_instrumental": make_instrumental,
                "metadata": {
                    "stream": False
                }
            }

            headers = {
                "Authorization": f"Bearer {self.current_token}",
                "Content-Type": "application/json",
            }

            url = f"{self.BASE_URL}/api/generate/v2/"
            logger.info(f"Sending POST request to Generate API: {url} with payload: {payload}")
            logger.debug(f"Final Payload Sent: {json.dumps(payload, indent=2)}")
            resp = self.session.post(url, json=payload, headers=headers)
            logger.debug(f"Generate POST Response: {resp.status_code} {resp.text}")
            resp.raise_for_status()

            logger.info("Song generation attempt successful.")
            return resp.json()

        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to generate song: {e}")
            raise
        except Exception as e:
            logger.error(f"An error occurred during song generation: {e}")
            raise

    def get_song_status(self, song_id: str) -> dict:
        """
        GET /api/feed/ returns an array of your songs, each with:
            {
              "id": "...",
              "clips": [...],
              "status": "...",
              ...
            }

        We find the one with matching 'id' and return it.
        If not found, returns None.
        """
        if not self.current_token:
            self.keepAlive()

        headers = {
            "Authorization": f"Bearer {self.current_token}",
            "Content-Type": "application/json",
            "User-Agent": "Mozilla/5.0",
            "Accept": "application/json"
        }

        url = f"{self.BASE_URL}/api/feed/"
        logger.info(f"Fetching song status for ID: {song_id}")
        resp = self.session.get(url, headers=headers)
        resp.raise_for_status()

        data = resp.json()  # This is a list of songs
        if not isinstance(data, list):
            logger.error("Expected a list from /api/feed/, got something else.")
            return None

        matching = next((x for x in data if x.get("id") == song_id), None)
        return matching  # Could be None if not found

def initialize_suno_api() -> SunoApiPython:
    suno_cookie = config("SUNO_COOKIE", default="")
    if not suno_cookie:
        logger.error("SUNO_COOKIE isn't set up in environment variables.")
        raise Exception("SUNO_COOKIE isn't set up in environment variables.")

    suno_api = SunoApiPython(suno_cookie)
    suno_api.init()
    return suno_api

# Export the initialized suno API instance
suno_api_instance = initialize_suno_api()
