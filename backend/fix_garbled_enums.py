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
            
            print("All ENUM columns fixed successfully!")
        except Exception as e:
            print(f"Error while running ALTER TABLE: {e}")

if __name__ == "__main__":
    fix_enums()
