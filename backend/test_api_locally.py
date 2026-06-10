
import urllib.request
import json
try:
    req = urllib.request.Request('http://127.0.0.1:8000/api/v1/games/1077/participants/')
    with urllib.request.urlopen(req, timeout=5) as response:
        print('HTTP', response.status)
        print(response.read().decode('utf-8'))
except Exception as e:
    print('Error:', e)

