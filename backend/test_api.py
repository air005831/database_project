import urllib.request
import urllib.error

urls = ['http://localhost:8088/api/announcements', 'http://localhost:8088/api/games/']

for url in urls:
    try:
        response = urllib.request.urlopen(url)
        print(f"Success for {url}")
    except urllib.error.HTTPError as e:
        print(f"HTTP Error for {url}: {e.code}")
        body = e.read().decode('utf-8')
        # Django 500 error page usually has the exception in the title or a <textarea> or inside <pre class="exception_value">
        import re
        match = re.search(r'<pre class="exception_value">(.*?)</pre>', body, re.DOTALL | re.IGNORECASE)
        if match:
            print("Exception:", match.group(1).strip())
        else:
            match2 = re.search(r'<title>(.*?)</title>', body, re.IGNORECASE)
            if match2:
                print("Title:", match2.group(1).strip())
            else:
                print("Could not parse exception from body.")
