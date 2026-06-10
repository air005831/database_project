
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()
from api_v1.models import GameMatch, MatchParticipant
match = GameMatch.objects.last()
if match:
    parts = match.participants.all()
    print('Match:', match.id)
    for p in parts:
        print('User:', p.user.name, 'Gender:', p.user.gender)

