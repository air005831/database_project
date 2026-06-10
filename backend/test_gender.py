
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()
from api_v1.models import GameMatch
match = GameMatch.objects.last()
for p in match.participants.all():
    print(p.user.gender.encode('utf-8'))

