# Handles suno API requests, including GET and POST requests

from .suno_api import SunoApiPython
from decouple import config

suno_cookie = config("SUNO_COOKIE", default="")
api = SunoApiPython(suno_cookie)
api.init()

def generate_song(prompt: str):
    """
    Generate a song based on a prompt using suno API
    """
    result = api.generate_song(prompt)
    return result