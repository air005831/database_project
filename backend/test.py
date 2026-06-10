import urllib.request
import urllib.error
import json

try:
    req = urllib.request.Request('http://localhost:8088/api/users/2/public-profile/')
    # Need auth token, let's just make a user or use django test client
    print("Can't fetch without token from python easily, let's use django shell.")
except Exception as e:
    pass
