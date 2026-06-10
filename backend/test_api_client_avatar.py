
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from api_v1.serializers import GameMatchSerializer
from api_v1.models import GameMatch

gm = GameMatch.objects.get(id=1077)
sz = GameMatchSerializer(gm)
print(sz.data.get('participants'))

