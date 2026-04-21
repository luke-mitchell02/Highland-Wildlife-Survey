# https://pypi.org/project/watchdog/
import time
import sys
import csv
import json

from lxml import etree as lxml_etree
from watchdog.events import FileSystemEventHandler
from components import db, custom_logger
from watchdog.observers import Observer
from mysql.connector.cursor import MySQLCursor
from components.validation import (
    normalise_date,
    normalise_time,
    normalise_number,
    normalise_weather,
    normalise_boolean,
    verify_site,
    verify_volunteer,
    verify_session,
    verify_species
)

MONITORING_PATH = "ingestion/src/data_dropoff/"
XML_SCHEMA_PATH = "ingestion/src/schemas/sightings.xsd"
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
        path = str(event.src_path)

        if event.src_path.endswith(".csv"):
            self.process_csv(path)
        elif event.src_path.endswith(".xml"):
            self.process_xml(path)
        elif event.src_path.endswith(".json"):
            self.process_json(path)

    # File Handling
    def process_csv(self, path: str) -> None:
        conn = db.connect()
        cursor = conn.cursor(dictionary=True)

        try:
            with open(path) as csvfile:
                reader = csv.DictReader(csvfile)
                valid_rows = self.validate_rows(conn=conn, cursor=cursor, fieldnames=list(reader.fieldnames or []), rows=list(reader))

                if valid_rows:
                    self.upload_rows(conn, cursor, valid_rows)
        finally:
            cursor.close()
            conn.close()

    def process_json(self, path: str) -> None:
        conn = db.connect()
        cursor = conn.cursor(dictionary=True)

        try:
            with open(path) as f:
                data = json.load(f)
                rows = [{k: str(v) for k, v in row.items()} for row in data]
                fieldnames = list(rows[0].keys()) if rows else []
                valid_rows = self.validate_rows(conn=conn, cursor=cursor, fieldnames=fieldnames, rows=rows)

                if valid_rows:
                    self.upload_rows(conn, cursor, valid_rows)
        except json.JSONDecodeError:
            logger.error(f"JSON file is invalid and failed validation: {path}")
        finally:
            cursor.close()
            conn.close()

    def process_xml(self, path: str) -> None:
        conn = db.connect()
        cursor = conn.cursor(dictionary=True)

        try:
            schema = lxml_etree.XMLSchema(lxml_etree.parse(XML_SCHEMA_PATH))
            doc = lxml_etree.parse(path)

            if not schema.validate(doc):
                logger.error(f"XML file failed schema validation: {schema.error_log.last_error}")
                return

            root = doc.getroot()
            rows = [{child.tag: child.text or "" for child in sighting} for sighting in root.findall("sighting")]
            fieldnames = list(rows[0].keys()) if rows else []
            valid_rows = self.validate_rows(conn=conn, cursor=cursor, fieldnames=fieldnames, rows=rows)

            if valid_rows:
                self.upload_rows(conn, cursor, valid_rows)

        except lxml_etree.XMLSyntaxError:
            logger.error(f"XML file is invalid and failed validation: {path}")
        finally:
            cursor.close()
            conn.close()

    # Validation
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

    def validate_rows(self, conn, cursor: MySQLCursor, fieldnames: list, rows: list[dict]) -> list | None:
        schema = self.build_schema(cursor)

        # Ensure all keys match the schema
        if set(fieldnames) != set(schema.keys()):
            logger.error(f"The uploaded file does not match the template structure")
            return

        valid_rows = []
        for line_num, row in enumerate(rows, start=2):
            if set(row.keys()) != set(schema.keys()):  # Ensure consistent schema in JSON and XML
                logger.warning(f"Row #{line_num} -> fields do not match template structure")
                continue

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

            if is_valid:
                # Verify Session
                result = verify_session(conn, cursor, volunteer_id=new_row['volunteer']['volunteer_id'], site_id=new_row['site']['site_id'], date=new_row['session_date'], start_time=new_row['start_time'], end_time=new_row['end_time'])
                new_row['session_id'] = result['session_id']

                # Append new row
                valid_rows.append(new_row)

        logger.info(f"Validation Complete - Found {len(valid_rows)} valid row(s)")
        return valid_rows

    # Upload
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