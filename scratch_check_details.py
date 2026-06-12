import os
import django
import sys
import json

sys.path.append(os.path.join(os.getcwd(), 'backend'))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from api_v1.models import GameMatch, Venue, Court

print("--- Matches ---")
matches_data = []
for m in GameMatch.objects.all():
    venue_name = m.court.venue.name if m.court and m.court.venue else "None"
    city = m.court.venue.address.city if m.court and m.court.venue and m.court.venue.address else "None"
    district = m.court.venue.address.district if m.court and m.court.venue and m.court.venue.address else "None"
    matches_data.append({
        "id": m.id,
        "game_name": m.game_name,
        "match_status": m.match_status,
        "venue": venue_name,
        "city": city,
        "district": district
    })
print(json.dumps(matches_data, indent=2, ensure_ascii=False))

print("--- Venues ---")
venues_data = []
for v in Venue.objects.all():
    city = v.address.city if v.address else "None"
    district = v.address.district if v.address else "None"
    venues_data.append({
        "id": v.id,
        "name": v.name,
        "city": city,
        "district": district
    })
print(json.dumps(venues_data, indent=2, ensure_ascii=False))
