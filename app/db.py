import mysql.connector
import custom_logger
import os

from dotenv import load_dotenv

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

def select(query: str, params: tuple=None):
    conn = connect()
    cursor = conn.cursor()

    try:
        cursor.execute(operation=query, params=params)
        return cursor.fetchall()
    except mysql.connector.Error as err:
        logger.error(err)
    finally:
        cursor.close()
        conn.close()

def execute(query: str, params: tuple=None):
    conn = connect()
    cursor = conn.cursor()

    try:
        cursor.execute(operation=query, params=params)
        conn.commit()
    except mysql.connector.Error as err:
        logger.error(err)
    finally:
        cursor.close()
        conn.close()
