from rest_framework import serializers
from .models import (
    User, Sport, UserSportLevel, Address, Facility, Venue, Court, GameMatch, 
    MatchParticipant, FavoriteGame, 
    PenaltyRule, Report, Blacklist, Notification, GameBulletin,
    Feedback, FeedbackType, Announcement, TaiwanRegion
)

class UserSerializer(serializers.ModelSerializer):
    age = serializers.ReadOnlyField()

    class Meta:
        model = User
        fields = ('id', 'email', 'phone', 'name', 'birthday', 'age', 'credit_point', 'role', 'line_id', 'instagram')
        read_only_fields = ('credit_point', 'role')

class UserProfileSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField(source='id', read_only=True)
    age = serializers.ReadOnlyField()
    levels = serializers.SerializerMethodField()
    avatar = serializers.CharField(source='avatar_url', required=False, allow_null=True, allow_blank=True)

    class Meta:
        model = User
        fields = ('user_id', 'email', 'name', 'phone', 'birthday', 'gender', 'avatar', 'avatar_url', 'bio', 'age', 'credit_point', 'role', 'levels', 'line_id', 'instagram')

    def get_levels(self, obj):
        res = {}
        for usl in obj.sport_levels.all():
            sport_name = usl.sport.chinese_name
            level_char = usl.level[0] if usl.level else 'C'
            
            # 統一映射到標準名稱
            if sport_name == "羽毛球":
                sport_name = "羽球"
                
            # 如果已經有較高等級的紀錄，避免被預設的 C 覆蓋
            if sport_name in res:
                if res[sport_name] == 'C' and level_char != 'C':
                    res[sport_name] = level_char
            else:
                res[sport_name] = level_char

        # 為了相容其他可能使用「羽毛球」的情境，把兩者同步
        if "羽球" in res:
            res["羽毛球"] = res["羽球"]

        return res

class SportSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source='chinese_name', read_only=True)

    class Meta:
        model = Sport
        fields = ('id', 'name')

class UserSportLevelSerializer(serializers.ModelSerializer):
    sport_name = serializers.CharField(source='sport.chinese_name', read_only=True)

    class Meta:
        model = UserSportLevel
        fields = ('id', 'sport', 'sport_name', 'level', 'updated_at')

class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = '__all__'

class VenueSerializer(serializers.ModelSerializer):
    address_detail = AddressSerializer(source='address', read_only=True)
    facilities = serializers.SlugRelatedField(many=True, read_only=True, slug_field='name')
    # 1. 定義寫入專用的唯寫虛擬欄位 (Write-Only Fields)
    city = serializers.CharField(write_only=True, required=False, allow_blank=True)
    district = serializers.CharField(write_only=True, required=False, allow_blank=True)
    street_line = serializers.CharField(write_only=True, required=False, allow_blank=True)
    sport_id = serializers.IntegerField(write_only=True, required=False, allow_null=True)
    court_count = serializers.IntegerField(write_only=True, required=False, allow_null=True)
    
    class Meta:
        model = Venue
        fields = (
            'id', 'name', 'address', 'address_detail', 'opening_hours',
            'facilities',
            'city', 'district', 'street_line', 'sport_id', 'court_count'
        )
    # 2. 於 representation 中動態加入 court_count，避免欄位名稱衝突
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # 統計關聯的球場數量
        representation['court_count'] = instance.courts.count()
        # 動態加入場館支援的運動（從所有球場的 sports 聚合）
        sport_ids = set()
        for court in instance.courts.prefetch_related('sports').all():
            for sport in court.sports.all():
                sport_ids.add(sport.id)
        representation['sport_ids'] = list(sport_ids)
        # 動態加入讀取的地址欄位，讓前端可以直接讀取 v.city 和 v.district
        if instance.address:
            representation['city'] = instance.address.city
            representation['district'] = instance.address.district
            representation['street_line'] = instance.address.street_line
        else:
            representation['city'] = ""
            representation['district'] = ""
            representation['street_line'] = ""
        return representation
    # 3. 處理 POST 建立邏輯
    def create(self, validated_data):
        city = validated_data.pop('city', None)
        district = validated_data.pop('district', None)
        street_line = validated_data.pop('street_line', None)
        sport_id = validated_data.pop('sport_id', None)
        court_count = validated_data.pop('court_count', None)
        # 自動處理 Address 外鍵 (若不存在則新增)
        if city or district or street_line:
            address_obj, created = Address.objects.get_or_create(
                city=city or '',
                district=district or '',
                street_line=street_line or ''
            )
            validated_data['address'] = address_obj
        # 建立場館
        venue = super().create(validated_data)
        # 根據 court_counts 批量自動生成球場
        court_counts = self.initial_data.get('court_counts', None)
        if court_counts:
            for item in court_counts:
                s_id = item.get('sport_id')
                count = item.get('count', 0)
                if s_id and count:
                    try:
                        sport_obj = Sport.objects.get(id=s_id)
                        for _ in range(count):
                            court = Court.objects.create(venue=venue)
                            court.sports.add(sport_obj)
                    except Sport.DoesNotExist:
                        pass
        # 根據 court_count 數量與 sport_id 自動生成球場 (備用/舊版)
        elif court_count and sport_id:
            try:
                sport_obj = Sport.objects.get(id=sport_id)
                for _ in range(court_count):
                    court = Court.objects.create(venue=venue)
                    court.sports.add(sport_obj)
            except Sport.DoesNotExist:
                pass
        # 處理 facilities 寫入
        facilities_data = self.initial_data.get('facilities', None)
        if facilities_data is not None:
            for facility_name in facilities_data:
                facility_obj, created = Facility.objects.get_or_create(name=facility_name)
                venue.facilities.add(facility_obj)
        return venue
    # 4. 處理 PATCH / PUT 更新邏輯
    def update(self, instance, validated_data):
        city = validated_data.pop('city', None)
        district = validated_data.pop('district', None)
        street_line = validated_data.pop('street_line', None)
        sport_id = validated_data.pop('sport_id', None)
        court_count = validated_data.pop('court_count', None)
        # 若有提供地址資訊，進行地址更新或重新綁定
        if city is not None or district is not None or street_line is not None:
            current_address = instance.address
            new_city = city if city is not None else (current_address.city if current_address else '')
            new_dist = district if district is not None else (current_address.district if current_address else '')
            new_street = street_line if street_line is not None else (current_address.street_line if current_address else '')
            
            address_obj, created = Address.objects.get_or_create(
                city=new_city,
                district=new_dist,
                street_line=new_street
            )
            validated_data['address'] = address_obj
        # 更新場館資訊
        venue = super().update(instance, validated_data)
        # 同步球場數量與球場運動種類
        if court_count is not None or sport_id is not None:
            try:
                sport_obj = None
                if sport_id is not None:
                    sport_obj = Sport.objects.get(id=sport_id)
                
                current_courts = list(venue.courts.all())
                current_count = len(current_courts)
                
                # 如果要增設球場但沒有提供 sport_id，優先從現有球場取得運動種類
                if court_count is not None and current_count < court_count and sport_obj is None:
                    if current_count > 0:
                        sport_obj = current_courts[0].sports.first()
                    if sport_obj is None:
                        sport_obj = Sport.objects.first()
                        
                # 處理球場數量的增刪
                if court_count is not None:
                    if current_count < court_count:
                        for _ in range(court_count - current_count):
                            court = Court.objects.create(venue=venue)
                            if sport_obj:
                                court.sports.add(sport_obj)
                    elif current_count > court_count:
                        courts_to_delete = current_courts[court_count:]
                        for c in courts_to_delete:
                            c.delete()
                            
                # 如果有提供 sport_id，確保所有剩餘的球場均更新為指定的運動種類
                if sport_id is not None and sport_obj is not None:
                    for court in venue.courts.all():
                        court.sports.set([sport_obj])
            except Sport.DoesNotExist:
                pass
        # 處理 facilities 更新
        facilities_data = self.initial_data.get('facilities', None)
        if facilities_data is not None:
            venue.facilities.clear()
            for facility_name in facilities_data:
                facility_obj, created = Facility.objects.get_or_create(name=facility_name)
                venue.facilities.add(facility_obj)
        return venue


class CourtSerializer(serializers.ModelSerializer):
    venue_detail = VenueSerializer(source='venue', read_only=True)
    sports = serializers.PrimaryKeyRelatedField(queryset=Sport.objects.all(), many=True, write_only=True, required=False)
    sport_names = serializers.SerializerMethodField(read_only=True)
    sport_ids = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Court
        fields = ('id', 'venue', 'venue_detail', 'name', 'occupied', 'base_price', 'sports', 'sport_names', 'sport_ids')

    def get_sport_names(self, obj):
        return [sport.chinese_name for sport in obj.sports.all()]

    def get_sport_ids(self, obj):
        return [sport.id for sport in obj.sports.all()]

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        # Keep backward compatibility: the frontend expects the 'sports' key to contain the list of chinese names.
        ret['sports'] = ret.get('sport_names', [])
        return ret

    def create(self, validated_data):
        sports = validated_data.pop('sports', [])
        court = Court.objects.create(**validated_data)
        court.sports.set(sports)
        return court

    def update(self, instance, validated_data):
        sports = validated_data.pop('sports', None)
        court = super().update(instance, validated_data)
        if sports is not None:
            court.sports.set(sports)
        return court

class MatchParticipantUserSerializer(serializers.ModelSerializer):
    id = serializers.ReadOnlyField(source='user.id')
    phone = serializers.ReadOnlyField(source='user.phone')
    name = serializers.ReadOnlyField(source='user.name')
    age = serializers.ReadOnlyField(source='user.age')
    gender = serializers.ReadOnlyField(source='user.gender')
    avatar = serializers.ReadOnlyField(source='user.avatar_url')
    level = serializers.SerializerMethodField()

    class Meta:
        model = MatchParticipant
        fields = ('id', 'phone', 'name', 'age', 'gender', 'avatar', 'level')

    def get_level(self, obj):
        user = obj.user
        match = obj.match
        
        # 確保球局和運動分類存在
        if not match or not match.sport:
            return 'C'
            
        # 尋找該使用者對應此球局運動的等級紀錄
        sport_level = user.sport_levels.filter(sport=match.sport).first()
        
        if sport_level and sport_level.level:
            # 回傳等級的第一個字 (例如 'C(beginner)' -> 'C')
            return sport_level.level[0]
            
        return 'C' # 預設回傳 C

class GameMatchListSerializer(serializers.ModelSerializer):
    sport_id = serializers.PrimaryKeyRelatedField(queryset=Sport.objects.all(), source='sport')
    sport_name = serializers.CharField(source='sport.chinese_name', read_only=True)
    venue_name = serializers.CharField(source='court.venue.name', read_only=True)
    split_price = serializers.ReadOnlyField()
    current_players = serializers.SerializerMethodField()
    creator_id = serializers.ReadOnlyField(source='creator.id')
    participant_ids = serializers.SerializerMethodField()
    waitlist_ids = serializers.SerializerMethodField()
    location = serializers.SerializerMethodField()

    class Meta:
        model = GameMatch
        fields = [
            'id', 'game_name', 'sport_id', 'sport_name', 'venue_name', 'location', 'least_players', 'most_players',
            'current_players', 'target_level', 'booking_date', 'time_slot', 
            'split_price', 'booking_status', 'match_status', 'creator_id',
            'gender_limit', 'participant_ids', 'waitlist_ids'
        ]

    def get_location(self, obj):
        if obj.court and obj.court.venue:
            venue = obj.court.venue
            address_str = ""
            if hasattr(venue, 'address') and venue.address:
                address_str = f"{venue.address.city or ''}{venue.address.district or ''}"
            return f"{address_str}{venue.name}"
        return ""

    def get_current_players(self, obj):
        cnt = obj.participants.count()
        return min(cnt, obj.most_players)

    def get_participant_ids(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        regular_parts = all_parts[:obj.most_players]
        return [p.user.id for p in regular_parts]

    def get_waitlist_ids(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        waitlisted_parts = all_parts[obj.most_players:]
        return [p.user.id for p in waitlisted_parts]

def validate_venue_hours(venue, booking_date, time_slot):
    import re
    if not venue or not venue.opening_hours:
        return True, ""

    parts = time_slot.split('-')
    if len(parts) < 2:
        return True, ""
        
    start_time_str, end_time_str = parts[0].strip(), parts[1].strip()
    
    def parse_time_to_min(t_str):
        t_str = t_str.replace('：', ':').strip()
        t_parts = re.split(r'[:]', t_str)
        if len(t_parts) >= 2:
            return int(t_parts[0]) * 60 + int(t_parts[1])
        elif len(t_parts) == 1 and len(t_parts[0]) == 4:
            return int(t_parts[0][:2]) * 60 + int(t_parts[0][2:])
        return 0

    t_min = parse_time_to_min(start_time_str)
    end_min = parse_time_to_min(end_time_str)
    if end_min <= t_min:
        end_min += 1440
        
    is_weekend = booking_date.weekday() >= 5
    day_name = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"][booking_date.weekday()]
    
    opening_hours = venue.opening_hours

    # Format 1: weekdays/weekends
    if 'weekdays' in opening_hours or 'weekends' in opening_hours:
        range_str = opening_hours.get('weekends') if is_weekend else opening_hours.get('weekdays')
        if not range_str:
            return True, ""
        
        m = re.findall(r'(\d{1,2}[:：]\d{2})', range_str)
        if len(m) >= 2:
            r_start = parse_time_to_min(m[0])
            r_end = parse_time_to_min(m[1])
            if r_end <= r_start:
                r_end += 1440
            if r_end - r_start >= 1440:
                return True, ""
            if r_start <= t_min and end_min <= r_end:
                return True, ""
            else:
                return False, f"超出該場地當天營業時間 ({range_str})"
        return True, ""

    # Format 2: opening list
    opening = opening_hours.get('opening')
    if not opening or not isinstance(opening, list):
        return True, ""
        
    day_specific_entries = [e for e in opening if e.get('days') and e.get('days') != '全年24小時']
    if day_specific_entries:
        matching_entries = [e for e in day_specific_entries if day_name in e.get('days')]
        if not matching_entries:
            return False, f"該場地於 {day_name} 不開放營業"
    else:
        matching_entries = opening

    for entry in matching_entries:
        time_text = entry.get('time')
        if not time_text or time_text in ['無', '全年24小時']:
            continue
            
        if '不對外開放' in time_text or '不開放' in time_text or '無法開放' in time_text:
            m = re.findall(r'(\d{1,2}[:：]?\d{2}?)\s*[-~～至]\s*(\d{1,2}[:：]\d{2})', time_text)
            closed_ranges = []
            for r in m:
                closed_ranges.append((parse_time_to_min(r[0]), parse_time_to_min(r[1])))
                
            if not closed_ranges and not is_weekend:
                closed_ranges.append((8 * 60, 17 * 60))
            
            if closed_ranges:
                for r_start, r_end in closed_ranges:
                    if r_end <= r_start:
                        r_end += 1440
                    if t_min < r_end and r_start < end_min:
                        return False, f"此時段為該場地非開放時間：{time_text}"
                        
        elif '開放時間' in time_text or '開放' in time_text or '時段' in time_text:
            weekday_part = ""
            weekend_part = ""
            if '週六週日' in time_text or '假日' in time_text or '例假日' in time_text:
                parts = re.split(r'[，,；;。]', time_text)
                for p in parts:
                    if any(k in p for k in ['週六週日', '假日', '例假日', '週六', '週日']):
                        weekend_part += " " + p
                    else:
                        weekday_part += " " + p
            else:
                weekday_part = time_text
                
            active_part = weekend_part if is_weekend else weekday_part
            if not active_part.strip():
                active_part = time_text
                
            m = re.findall(r'(\d{1,2}[:：]?\d{2}?)\s*[-~～至]\s*(\d{1,2}[:：]\d{2})', active_part)
            open_ranges = []
            for r in m:
                open_ranges.append((parse_time_to_min(r[0]), parse_time_to_min(r[1])))
                
            if open_ranges:
                matched = False
                for r_start, r_end in open_ranges:
                    if r_end <= r_start:
                        r_end += 1440
                    if r_end - r_start >= 1440:
                        matched = True
                        break
                    if r_start <= t_min and end_min <= r_end:
                        matched = True
                        break
                if not matched:
                    return False, f"此時段超出該場地開放時間：{time_text}"
            
    return True, ""

class GameMatchSerializer(serializers.ModelSerializer):
    sport_id = serializers.PrimaryKeyRelatedField(queryset=Sport.objects.all(), source='sport')
    court_id = serializers.PrimaryKeyRelatedField(queryset=Court.objects.all(), source='court', required=False, allow_null=True)
    venue_id = serializers.IntegerField(source='court.venue.id', read_only=True)
    sport_name = serializers.CharField(source='sport.chinese_name', read_only=True)
    venue_name = serializers.CharField(source='court.venue.name', read_only=True)
    split_price = serializers.ReadOnlyField()
    current_players = serializers.SerializerMethodField()
    current_waitlist = serializers.SerializerMethodField()
    max_waitlist = serializers.SerializerMethodField()
    participants = serializers.SerializerMethodField()
    waitlist = serializers.SerializerMethodField()
    participant_ids = serializers.SerializerMethodField()
    waitlist_ids = serializers.SerializerMethodField()
    creator_id = serializers.ReadOnlyField(source='creator.id')
    facilities = serializers.SerializerMethodField()
    cancel_deadline = serializers.DateTimeField(required=False, allow_null=True)
    start_time = serializers.CharField(write_only=True, required=True)
    target_level = serializers.CharField(required=True)
    duration = serializers.CharField(required=False, default='2 小時')
    description = serializers.CharField(source='game_note', required=False, allow_null=True, allow_blank=True)
    announcements = serializers.SerializerMethodField()
    location = serializers.SerializerMethodField()

    def validate_target_level(self, value):
        valid_values = [choice[0] for choice in GameMatch.LEVEL_CHOICES]
        if value in valid_values:
            return value
        raise serializers.ValidationError("無效的等級名稱，必須為 '休閒'、'業餘' 或 '高手'。")

    class Meta:
        model = GameMatch
        fields = [
            'id', 'game_name', 'sport_id', 'sport_name', 'court_id', 'venue_id', 'venue_name', 'location', 'least_players', 'most_players',
            'current_players', 'target_level', 'booking_date', 'start_time', 'time_slot', 'duration', 'game_note', 'description',
            'total_price', 'split_price', 'deposit_required', 'cancel_deadline',
            'weather', 'air_index', 'booking_status',
            'match_status', 'participants', 'waitlist', 'participant_ids', 'waitlist_ids', 'current_waitlist', 'max_waitlist', 'creator_id', 'facilities',
            'gender_limit', 'announcements'
        ]
        read_only_fields = ('match_status', 'weather', 'air_index', 'facilities', 'time_slot')

    def get_location(self, obj):
        if obj.court and obj.court.venue:
            venue = obj.court.venue
            address_str = ""
            if hasattr(venue, 'address') and venue.address:
                address_str = f"{venue.address.city or ''}{venue.address.district or ''}"
            return f"{address_str}{venue.name}"
        return ""

    def get_facilities(self, obj):
        if obj.court and obj.court.venue:
            return [f.name for f in obj.court.venue.facilities.all()]
        return []

    def get_announcements(self, obj):
        latest = obj.bulletins.order_by('-created_at').first()
        return latest.content if latest else ""

    def get_current_players(self, obj):
        cnt = obj.participants.count()
        return min(cnt, obj.most_players)

    def get_current_waitlist(self, obj):
        cnt = obj.participants.count()
        return max(0, cnt - obj.most_players)

    def get_max_waitlist(self, obj):
        import math
        max_allowed = math.ceil(obj.most_players * 1.3)
        return max_allowed - obj.most_players

    def get_participant_ids(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        regular_parts = all_parts[:obj.most_players]
        return [p.user.id for p in regular_parts]

    def get_waitlist_ids(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        waitlisted_parts = all_parts[obj.most_players:]
        return [p.user.id for p in waitlisted_parts]

    def get_participants(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        regular_parts = all_parts[:obj.most_players]
        return MatchParticipantUserSerializer(regular_parts, many=True).data

    def get_waitlist(self, obj):
        all_parts = obj.participants.all().order_by('joined_at')
        waitlisted_parts = all_parts[obj.most_players:]
        return MatchParticipantUserSerializer(waitlisted_parts, many=True).data

    def validate_total_price(self, value):
        if value is not None and (value < 0 or value > 10000):
            raise serializers.ValidationError("價格必須介於 0 至 10,000 元之間。")
        return value

    def validate_gender_limit(self, value):
        if value not in ['不限', '限男', '限女']:
            raise serializers.ValidationError("性別限制必須為 '不限'、'限男' 或 '限女'。")
        return value

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        if instance.time_slot and '-' in instance.time_slot:
            ret['start_time'] = instance.time_slot.split('-')[0].strip()
            try:
                t1, t2 = instance.time_slot.split('-')
                import datetime
                dt1 = datetime.datetime.strptime(t1.strip(), "%H:%M")
                dt2 = datetime.datetime.strptime(t2.strip(), "%H:%M")
                diff_hours = (dt2 - dt1).total_seconds() / 3600.0
                if diff_hours < 0:
                    diff_hours += 24
                if diff_hours.is_integer():
                    ret['duration'] = f"{int(diff_hours)} 小時"
                else:
                    ret['duration'] = f"{diff_hours} 小時"
            except Exception:
                ret['duration'] = "2 小時"
        else:
            ret['start_time'] = ""
            ret['duration'] = "2 小時"

        # 人數達標時將招募中狀態轉換為已成團，優化前端顯示效果
        if instance.match_status == 'recruiting' and instance.current_players_count >= instance.least_players: 
            ret['match_status'] = 'established'

        return ret


    def validate(self, attrs):
        import datetime
        booking_date = attrs.get('booking_date')
        start_time_str = attrs.get('start_time')
        duration_str = attrs.get('duration')
        cancel_deadline = attrs.get('cancel_deadline')
        least_players = attrs.get('least_players')
        most_players = attrs.get('most_players')

        # 性別限制校驗：男生不能發起/修改為限女生團，女生不能發起/修改為限男生團
        gender_limit = attrs.get('gender_limit')
        if self.instance and gender_limit is None:
            gender_limit = self.instance.gender_limit
            
        if gender_limit and gender_limit != '不限':
            request = self.context.get('request')
            if request and request.user and request.user.is_authenticated:
                user_gender = request.user.gender
                if gender_limit == '限男' and user_gender != '男':
                    raise serializers.ValidationError({"gender_limit": "男性專屬球局只能由男生發起。"})
                elif gender_limit == '限女' and user_gender != '女':
                    raise serializers.ValidationError({"gender_limit": "女性專屬球局只能由女生發起。"})

        if self.instance:
            if not booking_date:
                booking_date = self.instance.booking_date
            if not start_time_str and self.instance.time_slot and '-' in self.instance.time_slot:
                start_time_str = self.instance.time_slot.split('-')[0].strip()
            if not duration_str:
                if self.instance.time_slot and '-' in self.instance.time_slot:
                    try:
                        t1, t2 = self.instance.time_slot.split('-')
                        import datetime
                        dt1 = datetime.datetime.strptime(t1.strip(), "%H:%M")
                        dt2 = datetime.datetime.strptime(t2.strip(), "%H:%M")
                        diff_hours = (dt2 - dt1).total_seconds() / 3600.0
                        if diff_hours < 0:
                            diff_hours += 24
                        if diff_hours.is_integer():
                            duration_str = f"{int(diff_hours)} 小時"
                        else:
                            duration_str = f"{diff_hours} 小時"
                    except Exception:
                        duration_str = '2 小時'
                else:
                    duration_str = '2 小時'
            if least_players is None:
                least_players = self.instance.least_players
            if most_players is None:
                most_players = self.instance.most_players
        else:
            if not duration_str:
                duration_str = '2 小時'
            if least_players is None:
                least_players = 1

        # 解決前端跨日或早晨球局 (台北時間 00:00 - 08:00) 因使用 .toISOString() 轉換成 UTC Date 導致日期少一天的問題。
        # 當傳入 booking_date 且其對應的 start_time 小時小於 8 時，自動將日期加一天以修正為正確的台北本地日期。
        if 'booking_date' in attrs and start_time_str:
            from django.utils.dateparse import parse_time
            st = parse_time(start_time_str)
            if st and st.hour < 8:
                booking_date = booking_date + datetime.timedelta(days=1)
                attrs['booking_date'] = booking_date

        # 1. 預約日期不能為過去
        from django.utils import timezone
        if booking_date and booking_date < timezone.localdate():
            raise serializers.ValidationError({"booking_date": "球局預約日期不能為過去的日期。"})

        # 2. 人數限制校驗
        if most_players is not None:
            if most_players <= 0:
                raise serializers.ValidationError({"most_players": "最多人數必須大於 0。"})
            if most_players < least_players:
                raise serializers.ValidationError({"most_players": "最多人數不能少於最少人數。"})

        if start_time_str and booking_date:
            import re
            hours = 2.0
            if duration_str:
                # 驗證持續時間格式與數值
                match = re.search(r'(\d+(\.\d+)?)', duration_str)
                if not match:
                    raise serializers.ValidationError({"duration": "持續時間格式不正確，必須包含有效小時數，例如：2 小時。"})
                hours = float(match.group(1))
                if hours <= 0 or hours > 24:
                    raise serializers.ValidationError({"duration": "持續時間必須介於 0.5 到 24 小時之間。"})
            
            from django.utils.dateparse import parse_time
            st = parse_time(start_time_str)
            if st:
                total_minutes = int(hours * 60)
                dt = datetime.datetime.combine(booking_date, st)
                dt_end = dt + datetime.timedelta(minutes=total_minutes)
                end_time_str = dt_end.strftime("%H:%M")
                attrs['time_slot'] = f"{start_time_str}-{end_time_str}"
                
                # 計算 cancel_deadline
                if not cancel_deadline:
                    from django.utils import timezone
                    start_datetime = timezone.make_aware(dt, timezone.get_current_timezone())
                    computed_deadline = start_datetime - timezone.timedelta(days=1)
                    now = timezone.now()
                    if computed_deadline < now:
                        computed_deadline = start_datetime - timezone.timedelta(hours=1)
                        if computed_deadline < now:
                            computed_deadline = now
                    attrs['cancel_deadline'] = computed_deadline
            else:
                raise serializers.ValidationError({"start_time": "起始時間格式不正確，例如：14:00。"})

        if not attrs.get('cancel_deadline'):
            if self.instance:
                attrs['cancel_deadline'] = self.instance.cancel_deadline
            else:
                from django.utils import timezone
                attrs['cancel_deadline'] = timezone.now()

        # 3. 驗證場地營業時間
        val_date = booking_date or (self.instance.booking_date if self.instance else None)
        val_time_slot = attrs.get('time_slot') or (self.instance.time_slot if self.instance else None)
        if val_date and val_time_slot:
            request = self.context.get('request')
            venue = None
            if request:
                venue_id = request.data.get('venue_id')
                court_id = request.data.get('court_id')
                if court_id:
                    court = Court.objects.filter(id=court_id).first()
                    if court:
                        venue = court.venue
                elif venue_id:
                    venue = Venue.objects.filter(id=venue_id).first()
            
            if not venue and self.instance and self.instance.court:
                venue = self.instance.court.venue

            if venue:
                is_open, err_msg = validate_venue_hours(venue, val_date, val_time_slot)
                if not is_open:
                    raise serializers.ValidationError({"time_slot": err_msg})

        attrs.pop('start_time', None)
        attrs.pop('duration', None)
        return attrs


class MatchParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = MatchParticipant
        fields = '__all__'

# class MatchWaitlistSerializer(serializers.ModelSerializer):
#     user_name = serializers.CharField(source='user.name', read_only=True)
# 
#     class Meta:
#         model = MatchWaitlist
#         fields = ('id', 'match', 'user', 'user_name', 'queue_position', 'status', 'joined_at')

class FavoriteGameSerializer(serializers.ModelSerializer):
    match_detail = GameMatchSerializer(source='match', read_only=True)

    class Meta:
        model = FavoriteGame
        fields = ('id', 'user', 'match', 'match_detail')

# class FavoriteVenueSerializer(serializers.ModelSerializer):
#     venue_detail = VenueSerializer(source='venue', read_only=True)
# 
#     class Meta:
#         model = FavoriteVenue
#         fields = ('id', 'user', 'venue', 'venue_detail', 'created_at')

class PenaltyRuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = PenaltyRule
        fields = '__all__'

class ReportSerializer(serializers.ModelSerializer):
    game_id = serializers.IntegerField(source='match_id', required=False)
    reported_user_id = serializers.IntegerField(source='offender_id', required=False)
    reporter_name = serializers.CharField(source='reporter.name', read_only=True)
    offender_name = serializers.CharField(source='offender.name', read_only=True)
    rule_detail = PenaltyRuleSerializer(source='rule', read_only=True)

    class Meta:
        model = Report
        fields = (
            'id', 'reporter', 'reporter_name', 'offender', 'offender_name',
            'match', 'rule', 'rule_detail', 'admin_note',
            'reviewed_at', 'reviewed_by', 'status',
            'game_id', 'reported_user_id', 'detail'
        )
        read_only_fields = ('reporter', 'reviewed_at', 'reviewed_by', 'status')
        extra_kwargs = {
            'match': {'required': False, 'allow_null': True},
            'offender': {'required': False, 'allow_null': True},
        }

class BlacklistSerializer(serializers.ModelSerializer):
    user_phone = serializers.CharField(source='user.phone', read_only=True)
    user_name = serializers.CharField(source='user.name', read_only=True)

    class Meta:
        model = Blacklist
        fields = ('id', 'user', 'user_phone', 'user_name', 'added_at', 'removed_at')

# class UserAvailabilitySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = UserAvailability
#         fields = (
#             'id', 'available_dates', 'time_slots', 'preferred_city',
#             'preferred_district', 'latitude', 'longitude', 'search_radius_km'
#         )

class NotificationSerializer(serializers.ModelSerializer):
    notification_id = serializers.IntegerField(source='id', read_only=True)
    game_id = serializers.IntegerField(source='match.id', read_only=True)

    class Meta:
        model = Notification
        fields = ('notification_id', 'game_id', 'message', 'is_read', 'created_at')

# class WeatherDataSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = WeatherData
#         fields = '__all__'

class GameBulletinSerializer(serializers.ModelSerializer):
    class Meta:
        model = GameBulletin
        fields = ('id', 'match', 'title', 'content', 'created_at')

class FeedbackSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.name', read_only=True)

    class Meta:
        model = Feedback
        fields = ('id', 'user', 'user_name', 'type', 'content', 'is_handled', 'admin_reply', 'created_at')
        read_only_fields = ('id', 'user', 'created_at')

class FeedbackTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeedbackType
        fields = '__all__'

class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Announcement
        fields = '__all__'

    def validate_photo(self, value):
        if value is None:
            return []
        if not isinstance(value, list):
            raise serializers.ValidationError("公告圖片格式必須為列表（Array）。")
        if len(value) > 3:
            raise serializers.ValidationError("公告圖片數量上限為 3 張。")
        for url in value:
            if not isinstance(url, str):
                raise serializers.ValidationError("公告圖片的 URL 必須是字串（String）。")
        return value

class TaiwanRegionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TaiwanRegion
        fields = '__all__'


class UserMatchHistorySerializer(serializers.ModelSerializer):
    sport_name = serializers.CharField(source='sport.chinese_name', read_only=True)
    title = serializers.CharField(source='game_name', read_only=True)
    status_chinese = serializers.SerializerMethodField()

    class Meta:
        model = GameMatch
        fields = ('id', 'game_name', 'title', 'sport_name', 'booking_date', 'time_slot', 'match_status', 'status_chinese')

    def get_status_chinese(self, obj):
        mapping = {
            'recruiting': '募集中',
            'full': '已額滿',
            'closed': '已結束',
            'started': '已開始',
            'failed_to_start': '流局'
        }
        return mapping.get(obj.match_status, obj.match_status)


class UserAdminDetailSerializer(serializers.ModelSerializer):
    age = serializers.ReadOnlyField()
    hosted_matches = serializers.SerializerMethodField()
    joined_matches = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id', 'email', 'phone', 'name', 'birthday', 'age', 'credit_point', 
            'role', 'line_id', 'instagram', 'gender', 'bio', 'avatar_url',
            'hosted_matches', 'joined_matches'
        )
        read_only_fields = ('credit_point', 'role')

    def get_hosted_matches(self, obj):
        matches = obj.created_matches.all().order_by('-id')
        return UserMatchHistorySerializer(matches, many=True).data

    def get_joined_matches(self, obj):
        matches = GameMatch.objects.filter(participants__user=obj).exclude(creator=obj).order_by('-id')
        return UserMatchHistorySerializer(matches, many=True).data

