# Basic configurations for the server
from decouple import config

SUNO_COOKIE = config("SUNO_COOKIE", default="")