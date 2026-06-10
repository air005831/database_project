
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()
from api_v1.models import GameMatch
from api_v1.serializers import GameMatchSerializer
match = GameMatch.objects.last()
data = GameMatchSerializer(match).data
print('Participants:', data['participants'])

