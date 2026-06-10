
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()
from api_v1.models import User
genders = User.objects.values_list('gender', flat=True).distinct()
for g in genders:
    if g:
        print(repr(g), [ord(c) for c in g])

