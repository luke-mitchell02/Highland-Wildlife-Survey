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
    'fog'
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

# Validators


def is_valid_email(value: str) -> bool:
    if re.match(r"[^@]+@[^@]+\.[^@]+", value):
        return True

    return False


def is_valid_site(cursor: MySQLCursor, value: str) -> bool:
    result = db.select(cursor=cursor, query="SELECT EXISTS(SELECT 1 FROM Sites WHERE site_name = %s)", params=[value])
    return bool(result[0][0])


def is_valid_species(cursor: MySQLCursor, value: str) -> bool:
    result = db.select(cursor=cursor, query="SELECT EXISTS(SELECT 1 FROM Species WHERE species_name = %s)", params=[value])
    return bool(result[0][0])