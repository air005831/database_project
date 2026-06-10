
import urllib.request
import json
try:
    req = urllib.request.Request('http://127.0.0.1:8088/api/games/')
    with urllib.request.urlopen(req, timeout=5) as response:
        print('HTTP', response.status)
        data = json.loads(response.read().decode('utf-8'))
        print('Success. Keys:', data.keys() if isinstance(data, dict) else len(data))
except Exception as e:
    print('Error:', e)

