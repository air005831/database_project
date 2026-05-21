from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import GameMatchViewSet

router = DefaultRouter()
router.register(r'games', GameMatchViewSet, basename='game')

urlpatterns = [
    path('', include(router.urls)),
]
