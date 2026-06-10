import MySQLdb
try:
    conn = MySQLdb.connect(host='localhost', user='root', password='', database='nojo')
    c = conn.cursor()
    c.execute('DESCRIBE notification;')
    print("Notification table:")
    for row in c.fetchall():
        print(row)
except Exception as e:
    print('Error:', e)
