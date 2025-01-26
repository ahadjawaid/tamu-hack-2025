# Handles Clerk handshake by using fresh cookies and discovering session ID along with adding JWT for authorization

import os
import time
import json
import requests
from decouple import config

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
            "User-Agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Mobile Safari/537.36",
            "Cookie": suno_cookie,      
        })

    def init(self):
        self.getAuthToken()  
        self.keepAlive()      

    def getAuthToken(self):
        url = f"{self.CLERK_URL}/v1/client?_clerk_js_version={self.CLERK_VERSION}"
        resp = self.session.get(url)
        resp.raise_for_status()
        data = resp.json()

        if "response" not in data or "last_active_session_id" not in data["response"]:
            raise Exception("Failed to get session ID from Clerk. Check if cookie is correct.")

        self.sid = data["response"]["last_active_session_id"]

    def keepAlive(self):
        """
        Equivalent to POST /v1/client/sessions/{sid}/tokens?__clerk_js_version=CLERK_VERSION
        to get a *fresh* JWT and store in self.current_token
        """
        if not self.sid:
            raise Exception("No session ID set, can't keepAlive.")
        url = f"{self.CLERK_URL}/v1/client/sessions/{self.sid}/tokens?_clerk_js_version={self.CLERK_VERSION}"
        resp = self.session.post(url)
        resp.raise_for_status()

        data = resp.json()
        if "jwt" not in data:
            raise Exception("Failed to get fresh JWT from Clerk. Check your cookie.")
        self.current_token = data["jwt"]

    def generate_song(self, prompt: str, make_instrumental=False, model="chirp-v3-5", wait_audio=False) -> dict:

        # Refresh the token
        self.keepAlive()

        payload = {
            "make_instrumental": make_instrumental,
            "mv": model,
            "prompt": "",
            "generation_type": "TEXT",
            "gpt_description_prompt": prompt
        }

        headers = {
            "Authorization": f"Bearer {self.current_token}",
            "Content-Type": "application/json",  
            "User-Agent": "Mozilla/5.0 (Linux; Android 6.0; ...)"
        }

        url = f"{self.BASE_URL}/api/generate/v2/"
        resp = self.session.post(url, json=payload, headers=headers)
        if resp.status_code != 200:
            raise Exception(f"Generate song call failed: {resp.status_code} {resp.text}")

        return resp.json()
