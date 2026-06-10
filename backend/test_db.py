import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.contrib.auth import get_user_model
from api_v1.serializers import UserProfileSerializer

User = get_user_model()
try:
    user = User.objects.last()
    serializer = UserProfileSerializer(user)
    print("Last user ID:", user.id)
    print("Serialized data:", serializer.data)
except Exception as e:
    print(e)
