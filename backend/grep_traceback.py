import urllib.request
import urllib.error

try:
    urllib.request.urlopen('http://localhost:8088/api/games/')
except urllib.error.HTTPError as e:
    body = e.read().decode('utf-8')
    # find lines mentioning 'views.py'
    for line in body.split('\n'):
        if 'views.py' in line or 'models.py' in line or 'serializers.py' in line:
            print(line.strip())
