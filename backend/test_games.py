import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from api_v1.models import GameMatch

games = GameMatch.objects.all()[:3]
for g in games:
    print(f'Game {g.id}: {g.match_status}')
