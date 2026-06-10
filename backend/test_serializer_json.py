
import os
import django
import json
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()
from api_v1.models import GameMatch
from api_v1.serializers import MatchParticipantUserSerializer
match = GameMatch.objects.last()
parts = match.participants.all()
data = MatchParticipantUserSerializer(parts, many=True).data
print(json.dumps(data, ensure_ascii=False))

