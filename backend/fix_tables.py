import MySQLdb
try:
    conn = MySQLdb.connect(host='localhost', user='root', password='', database='nojo')
    c = conn.cursor()
    c.execute('ALTER TABLE notification MODIFY game_id int(11) NULL;')
    c.execute('ALTER TABLE announcements ADD COLUMN photo JSON NULL;')
    conn.commit()
    print('Successfully modified notification.game_id to allow NULL, and added photo to announcements.')
    conn.close()
except Exception as e:
    print('Error:', e)
