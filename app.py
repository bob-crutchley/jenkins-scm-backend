from flask import Flask, request, send_from_directory
import pymysql.cursors
import os

app = Flask(__name__, static_url_path='')

def get_connection():
    return pymysql.connect(host=os.getenv("MYSQL_HOST"),
                             user=os.getenv("root"),
                             password=os.getenv("MYSQL_ROOT_PASSWORD"),
                             db=os.getenv("MYSQL_DATABASE"),
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

@app.route('/api/books')
def get_all_books():
    books = []
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM Books;"
            cursor.execute(sql)
            books = cursor.fetchall()
            return str(books)
    finally:
        connection.close()
