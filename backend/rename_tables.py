import sqlite3
import traceback

def rename_tables():
    conn = sqlite3.connect('db.sqlite3')
    c = conn.cursor()
    
    mapping = {
        'api_v1_user': 'users',
        'api_v1_sport': 'sports',
        'api_v1_usersportlevel': 'user_sport_levels',
        'api_v1_address': 'address',
        'api_v1_facility': 'facilities',
        'api_v1_venue': 'venues',
        'api_v1_court': 'court',
        'api_v1_courtconflict': 'court_conflicts',
        'api_v1_gamematch': 'gamesmatches',
        'api_v1_matchparticipant': 'match_participants',
        'api_v1_favoritegame': 'keep',
        'api_v1_penaltyrule': 'penalty_rules',
        'api_v1_report': 'reports',
        'api_v1_blacklist': 'blacklist',
        'api_v1_feedback': 'feedbacks',
        'api_v1_announcement': 'announcements',
        'api_v1_notification': 'notification',
        'api_v1_gamebulletin': 'game_bulletins'
    }
    
    for old_table, new_table in mapping.items():
        try:
            c.execute(f"ALTER TABLE {old_table} RENAME TO {new_table}")
            print(f"Renamed {old_table} to {new_table}")
        except sqlite3.Error as e:
            pass # Table might not exist or already renamed
            
    conn.commit()
    conn.close()
    print('Done renaming tables!')

rename_tables()
