import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()
try:
    user = User.objects.filter(name__contains='豈').first()
    if user:
        print("Name:", user.name)
        print("Phone:", user.phone)
        print("Birthday:", user.birthday)
        print("Bio:", user.bio)
        print("Avatar_url:", user.avatar_url)
    else:
        print("User not found")
except Exception as e:
    print(e)
