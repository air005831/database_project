import urllib.request
import urllib.error

try:
    urllib.request.urlopen('http://localhost:8088/api/games/')
except urllib.error.HTTPError as e:
    body = e.read().decode('utf-8')
    import re
    match = re.search(r'(?s)<div id="traceback_area".*?</div>', body)
    if match:
        print(match.group(0))
    else:
        print("Traceback not found in HTML.")
