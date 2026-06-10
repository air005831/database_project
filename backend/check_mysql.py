import MySQLdb
try:
    conn = MySQLdb.connect(host='localhost', user='root', password='')
    c = conn.cursor()
    c.execute('SHOW DATABASES;')
    databases = [row[0] for row in c.fetchall()]
    print('Connected to MySQL successfully.')
    print('Available databases:', databases)
    if 'nojo' not in databases:
        c.execute('CREATE DATABASE nojo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
        print('Created database: nojo')
    if 'nojo_django_db' not in databases:
        c.execute('CREATE DATABASE nojo_django_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
        print('Created database: nojo_django_db')
    conn.close()
except Exception as e:
    print('Failed to connect or create DB:', str(e))
