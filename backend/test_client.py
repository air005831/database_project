import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.test import Client
from django.contrib.auth import get_user_model

User = get_user_model()
c = Client()
try:
    user1 = User.objects.first()
    print("User1 ID:", user1.id)
    c.force_login(user1)
    response = c.get(f'/api/users/{user1.id}/public-profile/')
    print("Status code:", response.status_code)
    print("Data:", response.json())
except Exception as e:
    print(e)
