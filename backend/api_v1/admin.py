from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import (
    User, Sport, UserSportLevel, Venue, Court, 
    GameMatch, MatchParticipant, FavoriteGame, 
    FavoriteVenue, Report, Blacklist
)

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('phone', 'name', 'birthday', 'credit_point', 'role')
    list_filter = ('role',)
    search_fields = ('phone', 'name')
    ordering = ('phone',)

    fields = ('phone', 'name', 'password', 'birthday', 'role', 'credit_point')

@admin.register(Sport)
class SportAdmin(admin.ModelAdmin):
    list_display = ('id', 'name')
    search_fields = ('name',)

@admin.register(UserSportLevel)
class UserSportLevelAdmin(admin.ModelAdmin):
    list_display = ('user', 'sport', 'level')
    list_filter = ('level', 'sport')

@admin.register(Venue)
class VenueAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'address')
    search_fields = ('name', 'address')

@admin.register(Court)
class CourtAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'venue')
    list_filter = ('venue',)

@admin.register(GameMatch)
class GameMatchAdmin(admin.ModelAdmin):
    list_display = ('id', 'sport', 'court', 'match_status', 'booking_date', 'time_slot', 'most_players')
    list_filter = ('match_status', 'sport', 'booking_date')
    search_fields = ('sport__name', 'court__venue__name')

@admin.register(MatchParticipant)
class MatchParticipantAdmin(admin.ModelAdmin):
    list_display = ('match', 'user', 'is_confirmed', 'joined_at')
    list_filter = ('is_confirmed', 'joined_at')

@admin.register(FavoriteGame)
class FavoriteGameAdmin(admin.ModelAdmin):
    list_display = ('user', 'match', 'created_at')

@admin.register(FavoriteVenue)
class FavoriteVenueAdmin(admin.ModelAdmin):
    list_display = ('user', 'venue', 'created_at')

@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):
    list_display = ('reporter', 'offender', 'reason', 'status', 'created_at')
    list_filter = ('status', 'reason')
    search_fields = ('reporter__name', 'offender__name')

@admin.register(Blacklist)
class BlacklistAdmin(admin.ModelAdmin):
    list_display = ('user', 'created_at')
    search_fields = ('user__name', 'user__phone')
