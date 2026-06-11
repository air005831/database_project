import os
import sys
import django

# Add backend to path
sys.path.append(os.path.join(os.path.dirname(__file__)))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from django.db import connection

def fix_enums():
    print("[Fix] Redeclaring MySQL ENUM columns to fix garbled Chinese characters...")
    with connection.cursor() as cursor:
        try:
            # 1. Fix users.gender
            print("Changing users.gender...")
            cursor.execute("ALTER TABLE `users` MODIFY COLUMN `gender` ENUM('男','女','其他','不願透漏') NOT NULL")
            
            # 2. Fix gamesmatches columns
            print("Changing gamesmatches.target_level...")
            cursor.execute("ALTER TABLE `gamesmatches` MODIFY COLUMN `target_level` ENUM('休閒','業餘','高手') DEFAULT NULL")
            
            print("Changing gamesmatches.booking_status...")
            cursor.execute("ALTER TABLE `gamesmatches` MODIFY COLUMN `booking_status` ENUM('已佔到/已預約','未佔到/未預約','未確認') NOT NULL DEFAULT '未確認'")
            
            print("Changing gamesmatches.gender_limit...")
            cursor.execute("ALTER TABLE `gamesmatches` MODIFY COLUMN `gender_limit` ENUM('不限','限男','限女') NOT NULL DEFAULT '不限'")
            
            # 3. Align gamesmatches.match_status with Django STATUS_CHOICES
            print("Changing gamesmatches.match_status to align with Django choices...")
            cursor.execute("ALTER TABLE `gamesmatches` MODIFY COLUMN `match_status` ENUM('recruiting','full','closed','started','failed_to_start') NOT NULL DEFAULT 'recruiting'")
            
            # 4. Create taiwan_regions table if missing
            print("Ensuring taiwan_regions table exists...")
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS `taiwan_regions` (
                    `region_id` INT AUTO_INCREMENT PRIMARY KEY,
                    `city` VARCHAR(50) NOT NULL,
                    `district` VARCHAR(50) NOT NULL,
                    UNIQUE KEY `idx_city_district` (`city`, `district`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """)
            
            # 5. Seed taiwan_regions table
            print("Seeding taiwan_regions table...")
            regions_data = {
                '桃園市': [
                    '桃園區', '中壢區', '平鎮區', '八德區', '楊梅區', '蘆竹區',
                    '大溪區', '龍潭區', '龜山區', '大園區', '觀音區', '新屋區', '復興區'
                ],
                '台北市': [
                    '中正區', '大同區', '中山區', '松山區', '大安區', '萬華區',
                    '信義區', '士林區', '北投區', '內湖區', '南港區', '文山區'
                ],
                '新北市': [
                    '板橋區', '三重區', '中和區', '永和區', '新莊區', '新店區',
                    '土城區', '蘆洲區', '汐止區', '樹林區', '鶯歌區', '三峽區',
                    '淡水區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區',
                    '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區',
                    '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
                ],
                '台中市': [
                    '中區', '東區', '南區', '西區', '北區', '北屯區', '西屯區', '南屯區',
                    '太平區', '大里區', '霧峰區', '烏日區', '丰原區', '后里區', '石岡區',
                    '東勢區', '和平區', '新社區', '潭子區', '大雅區', '神岡區', '大肚區',
                    '沙鹿區', '龍井區', '梧棲區', '清水區', '大甲區', '外埔區', '大安區'
                ]
            }
            
            for city, districts in regions_data.items():
                for dist in districts:
                    cursor.execute("INSERT IGNORE INTO `taiwan_regions` (`city`, `district`) VALUES (%s, %s)", (city, dist))
            
            print("All fixes applied and database tables seeded successfully!")
        except Exception as e:
            print(f"Error while running database fixes: {e}")

if __name__ == "__main__":
    fix_enums()

