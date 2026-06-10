import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Landing.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace hardcoded colors with CSS variables
# Backgrounds
content = content.replace("'#f8fafc'", "'var(--bg-main)'")
content = content.replace("'#e2e8f0'", "'var(--border-color)'")
content = content.replace("'#cbd5e1'", "'#d1d5db'") # Slightly darker border for contrast if needed, or stick to var(--border-color)

# Primary color
content = content.replace("'#475569'", "'var(--primary-color)'")
content = content.replace("'#334155'", "'var(--primary-hover)'")
content = content.replace("'#7995a5'", "'var(--primary-color)'")

# Text colors
content = content.replace("'#1e293b'", "'var(--text-main)'")
content = content.replace("'#64748b'", "'var(--text-muted)'")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
