import re

from mysql.connector.cursor import MySQLCursor

from app.components import db
from datetime import datetime


WEATHER_ENUM = [
    'sunny',
    'clear',
    'cloudy',
    'light rain',
    'heavy rain',
    'hail',
    'sleet',
    'snow',
    'fog',
    'overcast',
    'windy'
]


def normalise_date(value: str) -> datetime | None:
    try:
        return datetime.strptime(value, "%Y-%m-%d")
    except ValueError:
        return None


def normalise_time(value: str) -> datetime | None:
    try:
        return datetime.strptime(value, "%H:%M")
    except ValueError:
        return None


def normalise_number(value: str, positive_only=True) -> int | None:
      try:
          num = int(value)
      except ValueError:
          return None

      if positive_only and num <= 0:
          return None

      return num


def normalise_weather(value: str) -> str | None:
    if value.lower() in WEATHER_ENUM:
        return value.title()

    return None


def normalise_boolean(value: str) -> bool | None:
    lower_value = value.lower()

    if lower_value in ['y', 'yes', 't', 'true', '1']:
        return True

    elif lower_value in ['n', 'no', 'f', 'false', '0']:
        return False

    return None


def verify_volunteer(cursor: MySQLCursor, value: str) -> dict | None:
    if not re.match(r"[^@]+@[^@]+\.[^@]+", value):
        return None

    return db.select(cursor=cursor, query="SELECT volunteer_id, first_name, last_name FROM Volunteers WHERE email = %s", params=[value], one=True)


def verify_site(cursor: MySQLCursor, value: str) -> dict | None:
    return db.select(cursor=cursor, query="SELECT site_id, site_name FROM Sites WHERE site_name = %s", params=[value], one=True)


def verify_species(cursor: MySQLCursor, value: str) -> bool:
    return db.select(cursor=cursor, query="SELECT species_id, species_name FROM Species WHERE species_name = %s", params=[value], one=True)


def verify_session(conn, cursor: MySQLCursor, volunteer_id: int, site_id: int, date: datetime, start_time: datetime, end_time: datetime) -> dict | None:
    existing_session = db.select(cursor=cursor, query="SELECT session_id FROM Sessions WHERE volunteer_id = %s AND site_id = %s AND `date` = %s", params=[volunteer_id, site_id, date.date()], one=True)

    if existing_session:
        return existing_session

    db.execute(conn=conn, cursor=cursor, query="INSERT INTO Sessions (volunteer_id, site_id, `date`, start_time, end_time) VALUES (%s, %s, %s, %s, %s)", params=[volunteer_id, site_id, date.date(), start_time, end_time])
    return db.select(cursor=cursor, query="SELECT session_id FROM Sessions WHERE volunteer_id = %s AND site_id = %s AND `date` = %s", params=[volunteer_id, site_id, date.date()], one=True)
