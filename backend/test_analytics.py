import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from api_v1.views import AdminAnalyticsView
from django.test import RequestFactory
from api_v1.models import User

user = User.objects.filter(role='admin').first()
factory = RequestFactory()
request = factory.get('/admin/analytics')
request.user = user

view = AdminAnalyticsView.as_view()
try:
    response = view(request)
    import json
    print(json.dumps(response.data, ensure_ascii=False, indent=2))
except Exception as e:
    import traceback
    traceback.print_exc()
