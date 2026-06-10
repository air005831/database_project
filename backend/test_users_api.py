import urllib.request
import urllib.error

try:
    response = urllib.request.urlopen('http://localhost:8088/api/users/')
    print("Success: ", response.read().decode('utf-8')[:500])
except urllib.error.HTTPError as e:
    print(f"HTTP Error: {e.code} - {e.reason}")
    print(e.read().decode('utf-8')[:500])
except Exception as e:
    print("Error:", e)
