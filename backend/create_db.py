import MySQLdb
try:
    conn = MySQLdb.connect(host='localhost', user='root', password='')
    c = conn.cursor()
    c.execute('CREATE DATABASE IF NOT EXISTS nojo_django_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
    conn.commit()
    print('Successfully created nojo_django_db in MySQL.')
    conn.close()
except Exception as e:
    print('Error:', e)
