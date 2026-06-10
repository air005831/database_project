import MySQLdb
try:
    conn = MySQLdb.connect(host='localhost', user='root', password='', database='nojo')
    c = conn.cursor()
    c.execute('ALTER TABLE users ADD COLUMN last_credit_update DATETIME DEFAULT CURRENT_TIMESTAMP;')
    conn.commit()
    print('Successfully added last_credit_update to users table.')
    conn.close()
except Exception as e:
    print('Error:', e)
