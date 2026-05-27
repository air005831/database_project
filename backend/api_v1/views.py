from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import (
    GameMatch, MatchParticipant, UserSportLevel, 
    Blacklist, User, Sport, Venue, Court
)
from .serializers import (
    GameMatchSerializer, UserSerializer, SportSerializer,
    VenueSerializer, CourtSerializer, MatchParticipantSerializer
)

class UserViewSet(viewsets.ModelViewSet):
    """
    處理使用者資料的 ViewSet
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer

class SportViewSet(viewsets.ModelViewSet):
    queryset = Sport.objects.all()
    serializer_class = SportSerializer

class VenueViewSet(viewsets.ModelViewSet):
    queryset = Venue.objects.all()
    serializer_class = VenueSerializer

class CourtViewSet(viewsets.ModelViewSet):
    queryset = Court.objects.all()
    serializer_class = CourtSerializer

class MatchParticipantViewSet(viewsets.ModelViewSet):
    queryset = MatchParticipant.objects.all()
    serializer_class = MatchParticipantSerializer

class GameMatchViewSet(viewsets.ReadOnlyModelViewSet):
    """
    1. 獲取球場房間清單與天氣指數 (List/Retrieve)
    2. 使用者點擊加入球局房間 (Join action)
    """
    queryset = GameMatch.objects.all()
    serializer_class = GameMatchSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        queryset = GameMatch.objects.select_related(
            'sport', 'court__venue'
        ).prefetch_related(
            'participants__user'
        ).all()
        sport_id = self.request.query_params.get('sport_id')
        target_level = self.request.query_params.get('target_level')
        city = self.request.query_params.get('city')

        if sport_id:
            queryset = queryset.filter(sport_id=sport_id)
        if target_level:
            queryset = queryset.filter(target_level=target_level)
        if city:
            queryset = queryset.filter(court__venue__address__contains=city)
        
        return queryset

    @action(detail=True, methods=['post'], url_path='join')
    def join(self, request, pk=None):
        match = self.get_object_or_404(GameMatch, pk=pk)
        user = request.user

        # 1. 檢查是否在黑名單
        if Blacklist.objects.filter(user=user).exists():
            return Response({"detail": "You are blacklisted from joining matches."}, status=status.HTTP_403_FORBIDDEN)

        # 2. 檢查是否已滿人
        if match.participants.count() >= match.most_players:
            return Response({"detail": "This match is already full."}, status=status.HTTP_400_BAD_REQUEST)

        # 3. 檢查是否已經在房間內
        if match.participants.filter(user=user).exists():
            return Response({"detail": "You are already a participant in this match."}, status=status.HTTP_400_BAD_REQUEST)

        # 4. 檢查程度是否符合 (假設符合 API 規範的程度檢查)
        user_level_obj = UserSportLevel.objects.filter(user=user, sport=match.sport).first()
        user_level = user_level_obj.level if user_level_obj else 'casual'
        
        # 簡單的程度匹配邏輯：必須剛好符合或是可以視需求調整
        # 這裡根據規範 "是否符合加入球局的 target_level"
        if user_level != match.target_level:
            return Response({
                "detail": f"Your level ({user_level}) does not match the target level ({match.target_level})."
            }, status=status.HTTP_400_BAD_REQUEST)

        # 5. 加入房間
        MatchParticipant.objects.create(match=match, user=user)
        
        # 6. 更新狀態 (如果滿了就改成 full)
        if match.participants.count() >= match.most_players:
            match.match_status = 'full'
            match.save()

        return Response({"detail": "Successfully joined the match."}, status=status.HTTP_201_CREATED)

    def get_object_or_404(self, model, pk):
        return get_object_or_404(model, pk=pk)
