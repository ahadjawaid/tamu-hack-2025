# Handles Clerk handshake by using fresh cookies and discovering session ID along with adding JWT for authorization
import os
import json
import requests
import logging
from decouple import config

logging.basicConfig(
    level=logging.DEBUG,
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
        self.sid = None
        self.current_token = None

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
        """
        Grabs the session ID from Clerk.
        """
        url = f"{self.CLERK_URL}/v1/client?_clerk_js_version={self.CLERK_VERSION}"
        logger.info(f"Getting session ID from Clerk: {url}")

        resp = self.session.get(url)
        logger.debug(f"Clerk GET Response: {resp.status_code} {resp.text}")
        resp.raise_for_status()
        data = resp.json()

        if "response" not in data or "last_active_session_id" not in data["response"]:
            raise Exception("Failed to get session ID from Clerk. Check your cookie.")

        self.sid = data["response"]["last_active_session_id"]
        logger.info(f"Session ID: {self.sid}")

    def keepAlive(self):
        """
        Renews the JWT token from Clerk using the session ID.
        """
        if not self.sid:
            raise Exception("No session ID set, can't keepAlive.")

        url = f"{self.CLERK_URL}/v1/client/sessions/{self.sid}/tokens?_clerk_js_version={self.CLERK_VERSION}"
        logger.info(f"Renewing JWT token from Clerk: {url}")

        resp = self.session.post(url)
        logger.debug(f"Clerk POST Response: {resp.status_code} {resp.text}")
        resp.raise_for_status()
        data = resp.json()

        if "jwt" not in data:
            raise Exception("Failed to get fresh JWT from Clerk.")

        self.current_token = data["jwt"]
        logger.info("JWT token renewed.")

    def generate_song(self, prompt: str, make_instrumental=False) -> dict:
        """
        Kick off generation with a minimal payload to avoid 422 issues.
        """
        self.keepAlive()

        payload = {
            "prompt": prompt,
            "generation_type": "AUDIO",
        }

        headers = {
            "Authorization": f"Bearer {self.current_token}",
            "Content-Type": "application/json",
        }

        url = f"{self.BASE_URL}/api/generate/v2/"
        logger.info(f"Sending POST request to Generate API: {url} with payload: {payload}")
        resp = self.session.post(url, json=payload, headers=headers)
        logger.debug(f"Generate POST Response: {resp.status_code} {resp.text}")
        resp.raise_for_status()

        logger.info("Song generation attempt successful.")
        return resp.json()


def initialize_suno_api() -> SunoApiPython:
    suno_cookie = config("SUNO_COOKIE", default="")
    print("DEBUG: suno_cookie=", suno_cookie)
    if not suno_cookie:
        raise Exception("SUNO_COOKIE isn't set in environment variables.")

    suno_api = SunoApiPython(suno_cookie)
    suno_api.init()
    return suno_api

# Create global instance
suno_api_instance = initialize_suno_api()
