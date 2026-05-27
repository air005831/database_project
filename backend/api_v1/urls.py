from django.urls import path, include
from rest_framework.routers import DefaultRouter
# 匯入你寫好的所有 ViewSet（請根據你 views.py 的實際命名調整）
from .views import (
    UserViewSet, 
    SportViewSet, 
    VenueViewSet, 
    CourtViewSet, 
    GameMatchViewSet, 
    MatchParticipantViewSet
)

router = DefaultRouter()

router.register('users', UserViewSet, basename='user')
router.register('sports', SportViewSet, basename='sport')
router.register('venues', VenueViewSet, basename='venue')
router.register('courts', CourtViewSet, basename='court')
router.register('games', GameMatchViewSet, basename='gamematch')
router.register('participants', MatchParticipantViewSet, basename='matchparticipant')

urlpatterns = [
    path('', include(router.urls)),
]