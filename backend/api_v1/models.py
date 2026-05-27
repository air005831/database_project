from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone

class UserManager(BaseUserManager):
    def create_user(self, phone, name, birthday, password=None, **extra_fields):
        if not phone:
            raise ValueError('The Phone number must be set')
        user = self.model(phone=phone, name=name, birthday=birthday, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, phone, name, birthday, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', 'admin')
        return self.create_user(phone, name, birthday, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    ROLE_CHOICES = (
        ('user', 'User'),
        ('admin', 'Admin'),
    )
    phone = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=100)
    birthday = models.DateField()
    credit_point = models.IntegerField(default=100)
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='user')
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)

    objects = UserManager()

    USERNAME_FIELD = 'phone'
    REQUIRED_FIELDS = ['name', 'birthday']

    @property
    def age(self):
        today = timezone.now().date()
        return today.year - self.birthday.year - ((today.month, today.day) < (self.birthday.month, self.birthday.day))

    def __str__(self):
        return f"{self.name} ({self.phone})"

class Sport(models.Model):
    name = models.CharField(max_length=100, unique=True) # e.g., Badminton, Basketball

    def __str__(self):
        return self.name

class UserSportLevel(models.Model):
    LEVEL_CHOICES = (
        ('casual', 'Casual'),
        ('intermediate', 'Intermediate'),
        ('advanced', 'Advanced'),
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sport_levels')
    sport = models.ForeignKey(Sport, on_delete=models.CASCADE)
    level = models.CharField(max_length=20, choices=LEVEL_CHOICES)

    class Meta:
        unique_together = ('user', 'sport')

class Venue(models.Model):
    name = models.CharField(max_length=255)
    address = models.TextField()

    def __str__(self):
        return self.name

class Court(models.Model):
    venue = models.ForeignKey(Venue, on_delete=models.CASCADE, related_name='courts')
    name = models.CharField(max_length=100) # e.g., Court A, Court B

    def __str__(self):
        return f"{self.venue.name} - {self.name}"

class GameMatch(models.Model):
    STATUS_CHOICES = (
        ('recruiting', 'Recruiting'),
        ('full', 'Full'),
        ('closed', 'Closed'),
    )
    LEVEL_CHOICES = (
        ('casual', 'Casual'),
        ('intermediate', 'Intermediate'),
        ('advanced', 'Advanced'),
    )
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_matches')
    sport = models.ForeignKey(Sport, on_delete=models.CASCADE)
    court = models.ForeignKey(Court, on_delete=models.CASCADE)
    least_players = models.IntegerField(default=1)
    most_players = models.IntegerField()
    target_level = models.CharField(max_length=20, choices=LEVEL_CHOICES)
    booking_date = models.DateField()
    time_slot = models.CharField(max_length=100) # e.g., "14:00-16:00"
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    deposit_required = models.BooleanField(default=False)
    cancel_deadline = models.DateTimeField()
    match_status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='recruiting')
    weather_index = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def split_price(self):
        if self.most_players > 0:
            return self.total_price / self.most_players
        return 0

    @property
    def current_players_count(self):
        return self.participants.count()

class MatchParticipant(models.Model):
    match = models.ForeignKey(GameMatch, on_delete=models.CASCADE, related_name='participants')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    is_confirmed = models.BooleanField(default=False)
    joined_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('match', 'user')

class FavoriteGame(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='favorite_games')
    match = models.ForeignKey(GameMatch, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'match')

class FavoriteVenue(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='favorite_venues')
    venue = models.ForeignKey(Venue, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'venue')

class Report(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('deducted', 'Deducted'),
        ('dismissed', 'Dismissed'),
    )
    REASON_CHOICES = (
        ('no_show', 'No Show'),
        ('not_paid', 'Not Paid'),
        ('bad_behavior', 'Bad Behavior'),
    )
    reporter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports_made')
    offender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports_received')
    match = models.ForeignKey(GameMatch, on_delete=models.SET_NULL, null=True)
    reason = models.CharField(max_length=20, choices=REASON_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    admin_note = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

class Blacklist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='blacklist_entries')
    reason = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Blacklisted: {self.user.phone}"
