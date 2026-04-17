import mysql.connector
import os

from dotenv import load_dotenv
from mysql.connector.cursor import MySQLCursor

from app.components import custom_logger

logger = custom_logger.get_logger()
load_dotenv()

def connect():
    conn = mysql.connector.connect(
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        host=os.getenv('DB_HOST'),
        port=os.getenv('DB_PORT'),
        database=os.getenv('DB_NAME')
    )
    return conn

def select(cursor: MySQLCursor, query: str, params: list=None):
    try:
        cursor.execute(operation=query, params=params)
        return cursor.fetchall()
    except mysql.connector.Error as err:
        logger.error(err)

def execute(cursor: MySQLCursor, query: str, params: tuple=None):
    try:
        cursor.execute(operation=query, params=params)
        conn.commit()
    except mysql.connector.Error as err:
        logger.error(err)