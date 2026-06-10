import os
import re

search_dir = r"C:\Users\User\Documents\antigravity\db_all\frontend\src"
pattern = re.compile(r"查看資料|參與名單", re.IGNORECASE)

for root, _, files in os.walk(search_dir):
    for file in files:
        if file.endswith(('.js', '.jsx', '.ts', '.tsx', '.css')):
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    for i, line in enumerate(f):
                        if pattern.search(line):
                            print(f"{filepath}:{i+1}: {line.strip()}")
            except Exception as e:
                pass
