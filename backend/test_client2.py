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
    c.force_login(user1)
    
    # Let's fetch user2's public profile
    user2 = User.objects.last()
    print("Fetching profile for user ID:", user2.id)
    response = c.get(f'/api/users/{user2.id}/public-profile/')
    print("Status code:", response.status_code)
    print("Data:", response.json())
except Exception as e:
    print(e)
