# Agile Project Plan

## Methodology

I have chosen Kanban for this project as it best suits a fast-paced cycle where the system flows as capacity allows, with priorities adjusted as requirements become clearer.

**Workflow columns:** To Do | Research Phase | In Progress | Done

Progress is tracked through GitHub commit history and GitHub Projects. I am also using GitHub issues as these integrate into the Kanban board.

---

## SMART User Stories and INVEST Task Breakdown

I have written a series of SMART User Stories which were designed following INVEST principles.

All the tasks in each story are Independent, Negotiable, Valuable, Estimable, Small, and Testable.

---

### US-01 - Database Schema

**As a** volunteer coordinator,
**I want** a normalised relational database covering volunteers, sites, species, sessions, sightings, and alerts,
**so that** survey data is stored without redundancy and can be queried consistently across all reporting needs.

**Acceptance criteria:** Schema implemented in MySQL, normalised to 3NF with each step documented, 50+ realistic records populated, all foreign key constraints enforced.

| Task                                                 | Priority | Estimate |
|------------------------------------------------------|----------|----------|
| Design ER diagram covering all 6 entities            | High     | 30m      |
| Document normalisation steps UNF → 1NF → 2NF → 3NF   | High     | 1.5h     |
| Write DDL (CREATE TABLE with PKs, FKs, constraints)  | High     | 45m      |
| Write triggers to auto-generate formatted unique IDs | High     | 15m      |
| Populate reference data (volunteers, sites, species) | Low      | 1h       |

---

### US-02 - SQL Queries

**As a** conservation analyst,
**I want** a set of SQL queries covering species frequency, volunteer rankings, seasonal trends, and endangered species sightings,
**so that** I can extract meaningful insights from the survey data without writing ad-hoc queries each time.

**Acceptance criteria:** 10+ queries implemented, covering JOINs, aggregates, subqueries, GROUP BY/HAVING, INSERT, UPDATE, and DELETE operations, all returning correct results against sample data.

| Task                                                          | Priority | Estimate |
|---------------------------------------------------------------|----------|----------|
| Write species frequency by site query (JOIN + GROUP BY)       | Medium   | 15m      |
| Write volunteer activity ranking query (aggregate + ORDER BY) | Medium   | 15m      |
| Write seasonal trend query (date filtering + GROUP BY)        | Medium   | 15m      |
| Write endangered species sightings query (JOIN + WHERE)       | Medium   | 15m      |
| Write sites with declining populations query (subquery)       | Medium   | 30m      |
| Write remaining 5+ queries (CRUD + HAVING + nested)           | Medium   | 1h       |

---

### US-03 - Stored Procedure

**As a** conservation analyst,
**I want** a stored procedure that accepts a species name and date range, calculates whether the population is increasing, decreasing, or stable, and automatically inserts an alert if the species is endangered and declining,
**so that** conservation alerts are triggered consistently without manual intervention.

**Acceptance criteria:** Procedure accepts species_name and date range parameters, uses conditional logic (IF/ELSE) to determine trend, inserts into Alerts table when conditions are met, returns trend result.

| Task                                                            | Priority | Estimate |
|-----------------------------------------------------------------|----------|----------|
| Write trend calculation logic (count sightings across periods)  | High     | 1h       |
| Add IF / ELSE branching for increasing / decreasing / stable    | High     | 10m      |
| Add conditional alert insertion for endangered + declining      | High     | 10m      |
| Test procedure against sample data for all three trend outcomes | High     | 30m      |

---

### US-04 - Database Indexes

**As a** database administrator,
**I want** at least two indexes with EXPLAIN output justifying each one,
**so that** frequently run trend and species queries perform efficiently as the dataset grows.

**Acceptance criteria:** 2+ indexes created, EXPLAIN output captured before and after for each, performance improvement documented and trade-offs discussed.

| Task                                                   | Priority | Estimate |
|--------------------------------------------------------|----------|----------|
| Identify the two slowest queries using EXPLAIN         | Medium   | 15m      |
| Create index 1 and capture before/after EXPLAIN output | Medium   | 30m      |
| Create index 2 and capture before/after EXPLAIN output | Medium   | 30m      |
| Document trade-offs (storage cost vs query speed)      | Low      | 1h       |

---

### US-05 - CSV Ingestion Pipeline

**As a** volunteer coordinator,
**I want** the pipeline to watch a folder and automatically ingest CSV sighting files, validating headers and every row before inserting valid records into the database,
**so that** volunteer submissions are processed unattended without requiring manual imports.

**Acceptance criteria:** Watchdog detects new CSV files, validates all 13 required fields, rejects invalid rows with a logged warning, inserts all valid rows in a single batch, logs a summary on completion.

| Task                                                                 | Priority | Estimate |
|----------------------------------------------------------------------|----------|----------|
| Set up folder monitoring to detect and respond to new incoming files | High     | 45m      |
| Implement header validation against schema                           | Medium   | 1h       |
| Implement per-field length validation                                | Low      | 15m      |
| Implement normalisers (date, time, weather, boolean, number)         | High     | 2h       |
| Implement DB lookup validators (volunteer, site, species)            | High     | 1h       |
| Implement session lookup/create logic                                | High     | 1h       |
| Implement batch database insertion for validated rows                | Medium   | 30m      |

---

### US-06 - JSON and XML Ingestion

**As a** volunteer coordinator,
**I want** the pipeline to also accept JSON and XML sighting files using the same validation logic as CSV,
**so that** partner organisations can submit data in their preferred format without a separate import process.

**Acceptance criteria:** JSON files parsed into the same row dict structure as CSV, XML files validated against XSD before parsing, both formats pass through shared validate_rows logic, sample files provided for both formats.

| Task                                                                                   | Priority | Estimate |
|----------------------------------------------------------------------------------------|----------|----------|
| Design a format-agnostic validation layer to handle CSV, JSON, and XML input uniformly | High     | 2.5h     |
| Implement a JSON ingestion handler                                                     | High     | 15m      |
| Write an XSD schema to validate incoming XML sighting files                            | High     | 15m      |
| Implement an XML ingestion handler with schema validation                              | High     | 30m      |
| Create JSON and XML templates and sample files                                         | Medium   | 45m      |

---

### US-07 - Error and Warning Logging to File

**As a** system operator,
**I want** all warnings, errors, and critical messages logged to a file as well as the console,
**so that** I can review failed ingestion after the fact without needing to be present when they occur.

**Acceptance criteria:** File handler added at WARNING level, logs written to app/logs/process.log, console output unchanged.

| Task                                                                               | Priority | Estimate |
|------------------------------------------------------------------------------------|----------|----------|
| Implement file logging at WARNING level alongside console output                   | High     | 30m      |
| Configure a plain-text formatter for file output, separate from console formatting | Medium   | 15m      |

---

### US-08 - JSON Report API

**As a** partner organisation,
**I want** a GET /report/site/:id endpoint that returns a structured JSON report of all sightings at a given site with nested session and species records,
**so that** I can programmatically consume and display survey data in my own systems.

**Acceptance criteria:** NestJS API connects to MySQL, queries sightings for the given site_id, returns nested JSON with site detail and sighting records, handles invalid site IDs with a 404 response.

| Task                                                                                   | Priority | Estimate |
|----------------------------------------------------------------------------------------|----------|----------|
| Initialise the NestJS API with a database connection                                   | High     | 45m      |
| Implement an endpoint to return all sightings for a given site as a nested JSON report | High     | 2h       |
| Write a query to fetch sightings with nested species and session data                  | Medium   | 1h       |
| Add input validation and error handling for invalid site requests                      | Low      | 1h       |

---

### US-09 - XML Alert Report

**As a** partner organisation,
**I want** a well-formed XML report of endangered species alerts with a validating XSD schema,
**so that** I can validate the structure before processing it in our own systems.

**Acceptance criteria:** XML output includes site details, species, trend direction, and recommended actions as nested elements, XSD schema validates the output, generation triggered by API endpoint or CLI command.

| Task                                                                              | Priority | Estimate |
|-----------------------------------------------------------------------------------|----------|----------|
| Design XML report structure and write XSD                                         | High     | 1h       |
| Implement report generation querying alerts with associated species and site data | High     | 2h       |
| Validate generated XML against XSD before returning                               | High     | 30m      |

---

## Deviations & Testing

See [testing/deviation_log.md](/testing/deviation_log.md) and [testing/test_log.md](/testing/test_log.md)