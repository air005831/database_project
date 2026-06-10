import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()
users = User.objects.filter(name__icontains='豈')
for u in users:
    print(u.id, u.name)
