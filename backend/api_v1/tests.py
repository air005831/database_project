import datetime
from django.test import TestCase
from django.utils import timezone
from api_v1.models import Sport, Venue, Court, Facility, TaiwanRegion, Address
from api_v1.serializers import VenueSerializer, validate_venue_hours

class VenueSystemTests(TestCase):
    def setUp(self):
        # Setup basic data
        self.sport_badminton = Sport.objects.create(id=2, name="羽毛球")
        self.sport_basketball = Sport.objects.create(id=1, name="籃球")
        self.sport_mahjong = Sport.objects.create(id=3, name="麻將")
        
        self.facility_parking = Facility.objects.create(id=1, name="免費車位")
        self.facility_shower = Facility.objects.create(id=2, name="熱水淋浴間")
        
        self.region_taipei = TaiwanRegion.objects.create(
            zipcode="106",
            city="台北市",
            district="大安區"
        )
        self.region_taoyuan = TaiwanRegion.objects.create(
            zipcode="330",
            city="桃園市",
            district="桃園區"
        )

    def test_validate_venue_hours_all(self):
        # Venue open everyday 08:00 - 22:00
        venue = Venue.objects.create(
            name="大安運動中心",
            address=Address.objects.create(zipcode=self.region_taipei, street_line="辛亥路"),
            opening_hours={
                "all": ["08:00", "22:00"],
                "regular_off": [],
                "special_off": []
            }
        )
        
        # Test valid booking
        date = datetime.date(2026, 6, 15)  # Monday
        valid, msg = validate_venue_hours(venue, date, "10:00-12:00")
        self.assertTrue(valid)
        self.assertEqual(msg, "")
        
        # Test booking out of range
        valid, msg = validate_venue_hours(venue, date, "22:00-23:00")
        self.assertFalse(valid)
        self.assertIn("超出該場地當天營業時間", msg)

    def test_validate_venue_hours_separated(self):
        # Weekdays: 09:00-21:00, Weekends: 08:00-23:00
        venue = Venue.objects.create(
            name="桃園運動中心",
            address=Address.objects.create(zipcode=self.region_taoyuan, street_line="中山路"),
            opening_hours={
                "weekday": ["09:00", "21:00"],
                "weekend": ["08:00", "23:00"],
                "regular_off": [],
                "special_off": []
            }
        )
        
        # Weekday check
        weekday = datetime.date(2026, 6, 15)  # Monday
        valid, msg = validate_venue_hours(venue, weekday, "08:30-10:00")
        self.assertFalse(valid) # opens at 09:00 on weekdays
        
        valid, msg = validate_venue_hours(venue, weekday, "20:00-21:00")
        self.assertTrue(valid)
        
        # Weekend check
        weekend = datetime.date(2026, 6, 14)  # Sunday
        valid, msg = validate_venue_hours(venue, weekend, "08:30-10:00")
        self.assertTrue(valid) # opens at 08:00 on weekends
        
        valid, msg = validate_venue_hours(venue, weekend, "21:00-22:30")
        self.assertTrue(valid) # open till 23:00 on weekends

    def test_validate_venue_hours_regular_off(self):
        # Regular off on Monday (1)
        venue = Venue.objects.create(
            name="公休運動館",
            address=Address.objects.create(zipcode=self.region_taipei, street_line="辛亥路"),
            opening_hours={
                "all": ["08:00", "22:00"],
                "regular_off": [1],
                "special_off": []
            }
        )
        
        monday = datetime.date(2026, 6, 15)  # Monday (weekday 0, regular_off 1)
        tuesday = datetime.date(2026, 6, 16)  # Tuesday
        
        valid, msg = validate_venue_hours(venue, monday, "10:00-12:00")
        self.assertFalse(valid)
        self.assertIn("固定公休", msg)
        
        valid, msg = validate_venue_hours(venue, tuesday, "10:00-12:00")
        self.assertTrue(valid)

    def test_validate_venue_hours_special_off(self):
        # Special off on 2026-10-10
        venue = Venue.objects.create(
            name="特休運動館",
            address=Address.objects.create(zipcode=self.region_taipei, street_line="辛亥路"),
            opening_hours={
                "all": ["08:00", "22:00"],
                "regular_off": [],
                "special_off": ["2026-10-10"]
            }
        )
        
        special_day = datetime.date(2026, 10, 10)
        normal_day = datetime.date(2026, 10, 11)
        
        valid, msg = validate_venue_hours(venue, special_day, "10:00-12:00")
        self.assertFalse(valid)
        self.assertIn("特殊休假不開放", msg)
        
        valid, msg = validate_venue_hours(venue, normal_day, "10:00-12:00")
        self.assertTrue(valid)

    def test_validate_venue_hours_over_midnight(self):
        # Over-midnight shift: 22:00 to 03:00 (next day)
        venue = Venue.objects.create(
            name="深夜運動館",
            address=Address.objects.create(zipcode=self.region_taipei, street_line="辛亥路"),
            opening_hours={
                "all": ["22:00", "03:00"],
                "regular_off": [],
                "special_off": []
            }
        )
        
        date = datetime.date(2026, 6, 15)
        # Booking entirely inside evening range
        valid, msg = validate_venue_hours(venue, date, "22:30-23:30")
        self.assertTrue(valid)
        
        # Booking crossing midnight
        valid, msg = validate_venue_hours(venue, date, "23:00-01:00")
        self.assertTrue(valid)
        
        # Booking entirely in morning range (representing slot of the session starting on that calendar date)
        valid, msg = validate_venue_hours(venue, date, "01:00-02:30")
        self.assertTrue(valid)
        
        # Booking outside range
        valid, msg = validate_venue_hours(venue, date, "15:00-17:00")
        self.assertFalse(valid)

    def test_venue_serializer_create(self):
        # Create venue using serializer
        data = {
            "name": "新莊體育館",
            "zipcode": "106", # Should resolve to region_taipei
            "street_line": "中華路一段123號",
            "opening_hours": {
                "all": ["09:00", "21:00"],
                "regular_off": [7],
                "special_off": []
            },
            "court_counts": [
                {"sport_id": 2, "count": 3}, # 3 badminton courts
                {"sport_id": 1, "count": 2}  # 2 basketball courts
            ],
            "facilities": [1, 2, "新興設施"] # two existing IDs, one new name
        }
        
        serializer = VenueSerializer(data=data)
        self.assertTrue(serializer.is_valid(), serializer.errors)
        venue = serializer.save()
        
        # Check address and region resolver
        self.assertEqual(venue.address.zipcode, self.region_taipei)
        self.assertEqual(venue.address.street_line, "中華路一段123號")
        
        # Check facilities
        fac_names = [f.name for f in venue.facilities.all()]
        self.assertIn("免費車位", fac_names)
        self.assertIn("熱水淋浴間", fac_names)
        self.assertIn("新興設施", fac_names)
        
        # Check courts generation
        courts = venue.courts.all()
        self.assertEqual(courts.count(), 5)
        
        badminton_courts = [c for c in courts if self.sport_badminton in c.sports.all()]
        basketball_courts = [c for c in courts if self.sport_basketball in c.sports.all()]
        self.assertEqual(len(badminton_courts), 3)
        self.assertEqual(len(basketball_courts), 2)

    def test_venue_serializer_update_reconcile(self):
        # 1. Setup initial venue with 3 badminton courts and 1 basketball court
        address = Address.objects.create(zipcode=self.region_taipei, street_line="辛亥路")
        venue = Venue.objects.create(name="老字號球館", address=address)
        
        for _ in range(3):
            c = Court.objects.create(venue=venue)
            c.sports.add(self.sport_badminton)
        for _ in range(1):
            c = Court.objects.create(venue=venue)
            c.sports.add(self.sport_basketball)
            
        self.assertEqual(venue.courts.count(), 4)
        
        # 2. Update via serializer: badminton count decrease to 1, basketball count increase to 3
        data = {
            "name": "新名稱球館",
            "zipcode": "330", # change region
            "street_line": "中山路99號",
            "court_counts": [
                {"sport_id": 2, "count": 1}, # Badminton 3 -> 1
                {"sport_id": 1, "count": 3}  # Basketball 1 -> 3
            ]
        }
        
        serializer = VenueSerializer(venue, data=data, partial=True)
        self.assertTrue(serializer.is_valid(), serializer.errors)
        updated_venue = serializer.save()
        
        # Check address changes
        self.assertEqual(updated_venue.name, "新名稱球館")
        self.assertEqual(updated_venue.address.zipcode, self.region_taoyuan)
        self.assertEqual(updated_venue.address.street_line, "中山路99號")
        
        # Check court reconciliation
        courts = updated_venue.courts.all()
        # Total count should be 1 + 3 = 4
        self.assertEqual(courts.count(), 4)
        
        badminton_courts = [c for c in courts if self.sport_badminton in c.sports.all()]
        basketball_courts = [c for c in courts if self.sport_basketball in c.sports.all()]
        
        self.assertEqual(len(badminton_courts), 1)
        self.assertEqual(len(basketball_courts), 3)
