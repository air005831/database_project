import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Landing.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add import
import_marker = "import { Users, CalendarHeart, Trophy, PlayCircle, Activity } from 'lucide-react';"
if import_marker in content:
    content = content.replace(import_marker, import_marker + "\nimport confetti from 'canvas-confetti';")

# 2. Add triggerConfetti function
func_marker = "  const navigate = useNavigate();\n"
trigger_func = """  const triggerConfetti = (e) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = (rect.left + rect.width / 2) / window.innerWidth;
    const y = (rect.top + rect.height / 2) / window.innerHeight;
    
    confetti({
      particleCount: 50,
      spread: 70,
      origin: { x, y },
      colors: ['#7995a5', '#94a3b8', '#cbd5e1', '#e2e8f0', '#475569'],
      disableForReducedMotion: true,
      zIndex: 1000
    });
  };
"""
if func_marker in content:
    content = content.replace(func_marker, func_marker + "\n" + trigger_func)

# 3. Add to headline
headline_search = "<h1 style={{ fontSize: '88px', fontWeight: '900', color: 'var(--text-main)', marginBottom: '24px', lineHeight: '1.05', letterSpacing: '-0.03em' }}>"
headline_replace = "<h1 onMouseEnter={triggerConfetti} style={{ fontSize: '88px', fontWeight: '900', color: 'var(--text-main)', marginBottom: '24px', lineHeight: '1.05', letterSpacing: '-0.03em', cursor: 'pointer' }}>"
content = content.replace(headline_search, headline_replace)

# 4. Add to feature cards
card_search = "              onMouseOver={(e) => e.currentTarget.style.transform = 'translateX(-8px)'}"
card_replace = "              onMouseEnter={(e) => triggerConfetti(e)}\n              onMouseOver={(e) => e.currentTarget.style.transform = 'translateX(-8px)'}"
content = content.replace(card_search, card_replace)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
