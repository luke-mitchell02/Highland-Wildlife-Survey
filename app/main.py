# https://pypi.org/project/watchdog/
import sys

import custom_logger
import time
import csv
import re
import db

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
from datetime import datetime

MONITORING_PATH = "./app/data_dropoff/"
logger = custom_logger.get_logger()

# Validators

def is_valid_date(value: str) -> bool:
    try:
        datetime.strptime(value, "%Y-%m-%d")
        return True
    except ValueError:
        return False

def is_valid_time(value: str) -> bool:
    try:
        datetime.strptime(value, "%H:%M")
        return True
    except ValueError:
        return False

def is_valid_number(value: str, positive_only=True) -> bool:
    try:
        num = float(value)

        if positive_only and num > 0:
            return True

        return False
    except ValueError:
        return False

def is_valid_email(value: str) -> bool:
    if re.match(r"[^@]+@[^@]+\.[^@]+", value):
        return True

    return False

def is_site_valid(value: str) -> bool:
    conn = db.connect()


class FileCreationListener(FileSystemEventHandler):
    def __init__(self):
        self.schema = {
            "first_name": {"required": True, "min_length": 1, "max_length": 64, "type": str},
            "last_name": {"required": True, "min_length": 1, "max_length": 64, "type": str},
            "email": {"required": True, "min_length": 1, "max_length": 255, "type": str, "validator": is_valid_email},
            "site_name": {"required": True, "min_length": 1, "max_length": 64, "type": str},
            "session_date": {"required": True, "min_length": 1, "max_length": 16, "type": is_valid_date},
            "start_time": {"required": True, "min_length": 1, "max_length": 16, "type": is_valid_time},
            "end_time": {"required": True, "min_length": 1, "max_length": 16, "type": is_valid_time},
            "species_name": {"required": True, "min_length": 1, "max_length": 64, "type": str},
            "count": {"required": True, "min_length": 1, "max_length": 4, "type": is_valid_number},
            "sighting_time": {"required": True, "min_length": 1, "max_length": 16, "type": is_valid_time},
            "weather": {"required": True, "min_length": 1, "max_length": 64, "type": str},
            "photo_submitted": {"required": True, "min_length": 1, "max_length": 1, "type": bool},
            "notes": {"required": False, "min_length": 1, "max_length": 99999, "type": str},
        }

    def on_created(self, event):
        if not event.src_path.endswith(".csv"):
            return

        logger.info(f"Event: {event.event_type}, Path: {event.src_path}")
        self.read_csv(str(event.src_path))

    def read_csv(self, path: str) -> None:
        with open(path) as csvfile:
            reader = csv.DictReader(csvfile)
            self.validate_rows(reader)

    def validate_rows(self, reader: csv.DictReader) -> list[list, list] | None:
        # Check if the file is empty
        if not reader.line_num:
            return

        # Ensure all headings
        existing_headings = set(reader.fieldnames)
        if set(reader.fieldnames) != existing_headings:
            logger.error(f"The uploaded CSV file does not match the template structure")
            return

        for row in reader:
            print(row)

event_handler = FileCreationListener()
observer = Observer()
observer.schedule(event_handler, MONITORING_PATH, recursive=True)
observer.start()
logger.info(f"Monitoring directory: {MONITORING_PATH}")

try:
    conn = db.connect()
    conn.close()
    logger.info("MySQL Connection Successful")
except Exception as e:
    logger.critical(f"MySQL Connection Error: {e}")
    sys.exit(0)


try:
    while True:
        time.sleep(1)
finally:
    observer.stop()
    observer.join()