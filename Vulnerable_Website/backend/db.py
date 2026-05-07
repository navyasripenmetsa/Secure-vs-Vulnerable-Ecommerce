import mysql.connector
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Navyasri@2006",
        database="sqli_demo"
    )