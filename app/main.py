# https://pypi.org/project/watchdog/
import time
import sys
import csv

from app.components.validation import *
from watchdog.events import FileSystemEventHandler
from app.components import db, custom_logger
from watchdog.observers import Observer
from mysql.connector.cursor import MySQLCursor

MONITORING_PATH = "./app/data_dropoff/"
logger = custom_logger.get_logger()

class FileCreationListener(FileSystemEventHandler):
    # Events
    def on_created(self, event):
        if not event.src_path.endswith(".csv"):
            return

        logger.info(f"Event: {event.event_type}, Path: {event.src_path}")
        self.process_csv(str(event.src_path))

    # Functions
    def process_csv(self, path: str) -> None:
        conn = db.connect()
        cursor = conn.cursor()

        try:
            with open(path) as csvfile:
                reader = csv.DictReader(csvfile)
                valid_rows = self.validate_rows(cursor, reader)

                if valid_rows:
                    self.upload_rows(cursor, valid_rows)
        finally:
            cursor.close()
            conn.close()

    def build_schema(self, cursor: MySQLCursor) -> dict:
        schema = {
            "first_name": {"min_length": 1, "max_length": 64, "validator": None, "normaliser": None},
            "last_name": {"min_length": 1, "max_length": 64, "validator": None, "normaliser": None},
            "email": {"min_length": 1, "max_length": 255, "validator": is_valid_email, "normaliser": None},
            "site_name": {"min_length": 1, "max_length": 64, "validator": lambda v: is_valid_site(cursor, v), "normaliser": None},
            "session_date": {"min_length": 1, "max_length": 16, "validator": None, "normaliser": normalise_date},
            "start_time": {"min_length": 1, "max_length": 16, "validator": None, "normaliser": normalise_time},
            "end_time": {"min_length": 1, "max_length": 16, "validator": None, "normaliser": normalise_time},
            "species_name": {"min_length": 1, "max_length": 64, "validator": lambda v: is_valid_species(cursor, v), "normaliser": None},
            "count": {"min_length": 1, "max_length": 4, "validator": None, "normaliser": normalise_number},
            "sighting_time": {"min_length": 1, "max_length": 16, "validator": None, "normaliser": normalise_time},
            "weather": {"min_length": 1, "max_length": 64, "validator": None, "normaliser": normalise_weather},
            "photo_submitted": {"min_length": 1, "max_length": 5, "validator": None, "normaliser": normalise_boolean},
            "notes": {"min_length": 0, "max_length": 2000, "validator": None, "normaliser": None},
        }
        return schema

    def validate_rows(self, cursor: MySQLCursor, reader: csv.DictReader) -> list | None:
        schema = self.build_schema(cursor)

        # Ensure all headings
        existing_headings = set(reader.fieldnames)
        if existing_headings != set(schema.keys()):
            logger.error(f"The uploaded CSV file does not match the template structure")
            return

        valid_rows = []
        for row in reader:
            line_num = reader.line_num
            is_valid = True

            for key, value in row.items():
                schema_detail = schema[key]

                if len(value) < schema_detail["min_length"] or len(value) > schema_detail["max_length"]:
                    logger.warning(f"Row #{line_num} -> {key} is not valid")
                    is_valid = False
                    break

                validator = schema_detail["validator"]
                if validator:
                    if not validator(value):  # Validator only returns True or False
                        logger.warning(f"Row #{line_num} -> {key} is not valid")
                        is_valid = False
                        break

                normaliser = schema_detail["normaliser"]
                if normaliser:
                    normalised_value = normaliser(value)
                    if normalised_value is None:
                        logger.warning(f"Row #{line_num} -> {key} is not valid")
                        is_valid = False
                        break

                    row[key] = normalised_value

            if is_valid:
                valid_rows.append(row)

        logger.info(f"Validation Complete - Found {len(valid_rows)} valid row(s)")
        return valid_rows

    def upload_rows(self, cursor: MySQLCursor, valid_rows: list) -> list | None:
        pass

        # Need to resolve the volunteer and their ID
        # Need to insert the Session and get the ID
        # Need to resolve the species ID
        # Then insert it all
        # db.executemany(cursor=cursor, query="INSERT INTO Sightings () VALUES ()")

try:
    conn = db.connect()
    conn.close()
    logger.info("MySQL Connection Successful")
except Exception as e:
    logger.critical(f"MySQL Connection Error: {e}")
    sys.exit(0)

event_handler = FileCreationListener()
observer = Observer()
observer.schedule(event_handler, MONITORING_PATH, recursive=True)
observer.start()
logger.info(f"Monitoring directory: {MONITORING_PATH}")

try:
    while True:
        time.sleep(1)
finally:
    observer.stop()
    observer.join()