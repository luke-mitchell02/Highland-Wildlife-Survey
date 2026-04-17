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
    def __init__(self) -> None:
         self.key_map = {
             'email': 'volunteer',
             'site_name': 'site',
             'species_name': 'species'
         }

    # Events
    def on_created(self, event):
        if not event.src_path.endswith(".csv"):
            return

        logger.info(f"Event: {event.event_type}, Path: {event.src_path}")
        self.process_csv(str(event.src_path))

    # Functions
    def process_csv(self, path: str) -> None:
        conn = db.connect()
        cursor = conn.cursor(dictionary=True)

        try:
            with open(path) as csvfile:
                reader = csv.DictReader(csvfile)
                valid_rows = self.validate_rows(conn, cursor, reader)

                if valid_rows:
                    self.upload_rows(conn, cursor, valid_rows)
        finally:
            cursor.close()
            conn.close()

    def build_schema(self, cursor: MySQLCursor) -> dict:
        schema = {
            "first_name": {"min_length": 1, "max_length": 64, "normaliser": None},
            "last_name": {"min_length": 1, "max_length": 64, "normaliser": None},
            "email": {"min_length": 1, "max_length": 255, "normaliser": lambda v: verify_volunteer(cursor, v)},
            "site_name": {"min_length": 1, "max_length": 64, "normaliser": lambda v: verify_site(cursor, v)},
            "session_date": {"min_length": 1, "max_length": 16, "normaliser": normalise_date},
            "start_time": {"min_length": 1, "max_length": 16, "normaliser": normalise_time},
            "end_time": {"min_length": 1, "max_length": 16, "normaliser": normalise_time},
            "species_name": {"min_length": 1, "max_length": 64, "normaliser": lambda v: verify_species(cursor, v)},
            "count": {"min_length": 1, "max_length": 4, "normaliser": normalise_number},
            "sighting_time": {"min_length": 1, "max_length": 16, "normaliser": normalise_time},
            "weather": {"min_length": 1, "max_length": 64, "normaliser": normalise_weather},
            "photo_submitted": {"min_length": 1, "max_length": 5, "normaliser": normalise_boolean},
            "notes": {"min_length": 0, "max_length": 2000, "normaliser": None},
        }
        return schema

    def validate_rows(self, conn, cursor: MySQLCursor, reader: csv.DictReader) -> list | None:
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
            new_row = {}

            # Loop over each key: value pair in the row and sanitise and build a new row
            for key, value in row.items():
                schema_detail = schema[key]

                if len(value) < schema_detail["min_length"] or len(value) > schema_detail["max_length"]:
                    logger.warning(f"Row #{line_num} -> {key} is not valid")
                    is_valid = False
                    break

                # Sanitise the data
                normaliser = schema_detail["normaliser"]
                if not normaliser:
                    new_row[key] = value
                    continue

                normalised_value = normaliser(value)
                if normalised_value is None:
                    logger.warning(f"Row #{line_num} -> {key} is not valid")
                    is_valid = False
                    break

                # Replace Key with more logical key name with dictionary value
                if key in self.key_map:
                    new_row[self.key_map[key]] = normalised_value
                    continue

                new_row[key] = normalised_value

            # Verify Session
            result = verify_session(conn, cursor, volunteer_id=new_row['volunteer']['volunteer_id'], site_id=new_row['site']['site_id'], date=new_row['session_date'], start_time=new_row['start_time'], end_time=new_row['end_time'])
            new_row['session_id'] = result['session_id']

            if is_valid:
                valid_rows.append(new_row)

        logger.info(f"Validation Complete - Found {len(valid_rows)} valid row(s)")
        return valid_rows

    def upload_rows(self, conn, cursor: MySQLCursor, valid_rows: list) -> None:
        rows = []

        for row in valid_rows:
            rows.append((row['session_id'], row['species']['species_id'], row['count'], row['sighting_time'].time(), row['weather'], row['notes'], row['photo_submitted']))

        db.executemany(conn, cursor, query="INSERT INTO Sightings (session_id, species_id, individuals_count, sighting_time, weather_conditions, notes, photo_submitted) VALUES (%s, %s, %s, %s, %s, %s, %s)", params=rows)
        logger.info(f"Inserted {len(rows)} row(s)")

# Test DB Connection
try:
    conn = db.connect()
    conn.close()
    logger.info("MySQL Connection Successful")
except Exception as e:
    logger.critical(f"MySQL Connection Error: {e}")
    sys.exit(0)

# Initialise Watchdog
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