from rest_framework import serializers
from .models import User, Sport, Venue, Court, GameMatch, MatchParticipant

class SportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sport
        fields = '__all__'

class VenueSerializer(serializers.ModelSerializer):
    class Meta:
        model = Venue
        fields = '__all__'

class CourtSerializer(serializers.ModelSerializer):
    venue = VenueSerializer(read_only=True)
    class Meta:
        model = Court
        fields = '__all__'

class GameMatchSerializer(serializers.ModelSerializer):
    sport_name = serializers.CharField(source='sport.name', read_only=True)
    venue_name = serializers.CharField(source='court.venue.name', read_only=True)
    split_price = serializers.ReadOnlyField()
    current_players = serializers.IntegerField(source='current_players_count', read_only=True)

    class Meta:
        model = GameMatch
        fields = [
            'id', 'sport_name', 'venue_name', 'least_players', 'most_players',
            'current_players', 'target_level', 'booking_date', 'time_slot',
            'total_price', 'split_price', 'weather_index', 'match_status'
        ]

class MatchParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = MatchParticipant
        fields = '__all__'
