# Highland Wildlife Survey Data Pipeline

> A conservation-critical automated pipeline for the Highland Wildlife Trust, processing volunteer sighting records from CSV ingestion through to JSON and XML reports for partner organisations.

---

## Overview

Volunteers submit wildlife sighting records via files dropped into a watched folder. The pipeline ingests these files, validates and cleans the data, stores it in a relational database, runs analysis algorithms to detect population trends and flag endangered species alerts, and exports reports for partner organisations. It runs from the command line and can process hundreds of files unattended.

> **Safety-critical context:** Inaccurate data could lead to wrong policy decisions about protected species. Lost or corrupted records could undermine years of survey work.

---

## System Architecture

| Layer               | Technology          | Responsibility                                                                   |
|---------------------|---------------------|----------------------------------------------------------------------------------|
| Data pipeline & CLI | Python              | Ingestion, validation, DB operations, analysis algorithms, stored procedures     |
| Report service      | JavaScript (NestJS) | Reads from DB, builds JSON/XML reports, serves via HTTP API for partner download |
| Database            | MySQL               | All survey data, fully normalised with indexes                                   |
| Data exchange       | CSV / JSON / XML    | Ingestion, report output, schema-validated XML                                   |

For component detail see [docs/components.md](docs/components.md).

---

## Prerequisites

- Python 3.12+
- Node.js 18+
- MySQL 8.0+
- Git

---

## Installation

**1. Clone the repository**

```bash
git clone `https://github.com/luke-mitchell02/Highland-Wildlife-Survey.git`
cd Highland-Wildlife-Survey
```

**2. Create and activate a virtual environment**

```bash
python -m venv .venv
source .venv/bin/activate      # macOS / Linux
.venv\Scripts\activate         # Windows
```

**3. Install dependencies**

```bash
pip install -r requirements.txt
```

---

## Database Setup

**1. Create the database and tables**

```bash
mysql -u <user> -p < docs/database_ddl.sql
```

This creates all tables, indexes, and the auto-ID triggers for `Sessions` and `Sightings`.

**2. Populate reference data**

The pipeline validates incoming records against `Volunteers`, `Sites`, and `Species`. These must contain data before any sighting files can be ingested.

---

## Environment Variables

Both the pipeline and the API require a `.env` file. Create one at `ingestion/src/.env` and another at `api/.env`, both with the same contents.

Copy the example below and change the values after the `=` signs to match your configuration.

```
DB_HOST=localhost
DB_PORT=3306
DB_NAME=wildlife_db
DB_USER=root
DB_PASSWORD=password
```

---

## Running the Pipeline

```bash
python ingestion/src/main.py
```

The pipeline logs a successful connection and begins monitoring:

```
18-Apr-26 10:00:00 - INFO - MySQL Connection Successful
18-Apr-26 10:00:00 - INFO - Monitoring directory: ./ingestion/src/data_dropoff/
```

Drop a sighting file into `ingestion/src/data_dropoff/`. Supported formats are CSV, JSON, and XML - use the templates in `ingestion/templates/` as a starting point.

| Format | Template                                      | Sample                                                |
|--------|-----------------------------------------------|-------------------------------------------------------|
| CSV    | `ingestion/templates/sightings_template.csv`  | `ingestion/sample_data/sample_sightings_clean_1.csv`  |
| JSON   | `ingestion/templates/sightings_template.json` | `ingestion/sample_data/sample_sightings_clean_1.json` |
| XML    | `ingestion/templates/sightings_template.xml`  | `ingestion/sample_data/sample_sightings_clean_1.xml`  |

The pipeline validates every row and logs warnings for any that fail. Only valid rows are inserted.

Press `Ctrl+C` to stop.

---

## Running the API

```bash
cd api
npm install
npm run start
```

The API runs on `http://localhost:3000` by default. Available endpoints:

| Method | Endpoint             | Description                             |
|--------|----------------------|-----------------------------------------|
| GET    | `/report/site/:id`   | JSON sighting report for a site         |
| GET    | `/report/alerts`     | XML report of endangered species alerts |

---

## Running the Tests

Unit tests have been created to cover indepth testing of the validation and normalisation logic in `ingestion/src/components/validation.py`.

```bash
python -m pytest testing/ -v
```

See [docs/test_log.md](/testing/test_log.md) for the full test log including unit test results, manual pipeline tests, and CRUD testing.

---

## Documentation

| Document                                                            | Description                                                    |
|---------------------------------------------------------------------|----------------------------------------------------------------|
| [docs/agile_plan.md](docs/agile_plan.md)                            | Agile project plan, user stories, and task breakdown           |
| [docs/components.md](docs/components.md)                            | Component breakdown                                            |
| [docs/architecture.md](docs/architecture.md)                        | System Architecture and Data Flow Diagrams                     |
| [docs/database.md](docs/database.md)                                | Database Design, Mormalisation, ER Diagram                     |
| [docs/security.md](docs/security.md)                                | Security Review, SQL Injection Analysis, Insider Threat        |
| [docs/technical_report.md](docs/technical_report.md)                | SQL vs NoSQL, JSON vs XML, Sustainability Analysis             |
| [docs/sustainability_security_statement.md](docs/sustainability.md) | Sustainability Analysis                                        |
| [docs/test_log.md](/testing/test_log.md)                            | Unit test results, manual pipeline tests, and CRUD testing     |
| [testing/deviation_log.md](testing/deviation_log.md)                | Log of deviations from the original plan and their resolutions |
