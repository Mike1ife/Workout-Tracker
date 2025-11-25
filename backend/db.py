import pymysql

conn = pymysql.connect(
    host="localhost",
    user="user",
    password="password",
    database="workout_tracker",
)


def get_connection() -> pymysql.Connect:
    return conn
