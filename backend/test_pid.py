
import psutil
for p in psutil.process_iter(['pid', 'cmdline']):
    if p.info['pid'] == 32012:
        print(p.info['cmdline'])

