# Highland Wildlife Survey Data Pipeline

> A conservation-critical automated pipeline for the Highland Wildlife Trust, processing volunteer sighting records from CSV ingestion through to JSON and XML reports for partner organisations.

---

## Overview

Volunteers submit wildlife sighting records via CSV files dropped into a watched folder. The pipeline ingests these files, validates and cleans the data, stores it in a relational database, runs analysis algorithms to detect population trends and flag endangered species alerts, and exports reports for partner organisations. It runs from the command line and can process hundreds of files unattended.

> **Safety-critical context:** Inaccurate data could lead to wrong policy decisions about protected species. Lost or corrupted records could undermine years of survey work.

---

## System Architecture

| Layer               | Technology          | Responsibility                                                                   |
|---------------------|---------------------|----------------------------------------------------------------------------------|
| Data pipeline & CLI | Python              | Ingestion, validation, DB operations, analysis algorithms, stored procedures     |
| Report service      | JavaScript (NestJS) | Reads from DB, builds JSON/XML reports, serves via HTTP API for partner download |
| Database            | MySQL               | All survey data, fully normalised with indexes                                   |
| Data exchange       | CSV / JSON / XML    | Ingestion, report output, schema-validated XML                                   |

---

## Functional Components

### Component 1 - Database Layer
*Modules: UI107005 A1 + UI107004 A1*

- **Schema:** ER diagram covering `volunteers`, `survey_sites`, `sightings`, `species`, `survey_sessions`, and `alerts`, normalised to 3NF with each step documented
- **Data:** 50+ records (auto-populated by the pipeline from CSV files)
- **Queries (10+):** species frequency by site, volunteer activity rankings, seasonal trends, endangered species sightings, sites with declining populations, and more
- **Indexes (2+):** with `EXPLAIN` justification, e.g. a composite index on `species + sighting_date` for trend queries
- **Stored procedure:** accepts a `species_name` and date range, calculates population trend (`increasing`, `decreasing`, or `stable` based on sighting counts), and automatically inserts an alert record when the species is endangered and declining

---

### Component 2 - Algorithms and Data Structures (Has been submitted separately)
*Modules: UI107001 A1 + A2*

| Structure / Algorithm           | Purpose                                                                                                                                                                                     |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Hash map** (custom)           | O(1) species lookup index during CSV ingestion, validating that a species exists in reference data. Implements insertion, search, deletion, and collision handling                          |
| **Binary search tree** (custom) | Stores sighting records ordered by date for efficient range queries (e.g. all sightings between March and June 2025). Implements insertion, search, in-order traversal, and range retrieval |
| **Merge sort** (custom)         | Sorts sighting records by multiple criteria (e.g. species then count descending) for report generation, and sorts volunteer leaderboards                                                    |
| **Binary search**               | Efficient lookups on sorted species lists; BST search handles date-range queries                                                                                                            |
| **Unit tests**                  | Full suite for all four, covering edge cases including empty structures, single element, duplicates, and worst-case inputs                                                                  |

---

### Component 3 - Data Pipeline and Exchange
*Modules: UI107004 A1 + A2 + UI107006 A4*

- **CSV Ingestion (Python):** Watches a folder for new CSV files. For each file it validates headers, validates every row (date format, species exists, count is positive, site exists), rejects invalid rows to an error log, and inserts valid rows into the database
- **JSON Report Generation (Node.js):** Connects to the database, queries all sightings at a given site, and produces a structured JSON report with nested sighting records, served via `GET /report/site/:id`
- **XML Report Generation (Python or Node.js):** Generates a well-formed XML report of endangered species alerts with a validating schema (XSD or DTD), including site details, species, trend data, and recommended actions as nested elements
- **XML Parsing (Python):** Imports partner survey data supplied as XML, extracts site name, species observed, and observation counts, then inserts into the database

---

### Component 4 - Documentation
*All modules*

- Agile project plan
- System design diagrams
- Comprehensive security review
- Technical report with Big-O analysis and trade-off comparisons
- Sustainability statement

---

## Agile Project Plan

I have decided to opt for a **Kanban** methodology for this project. I have chosen it as to me it makes most sense for a solo, fast-paced development cycle where work items flow continuously rather than in fixed sprints.

**Workflow columns:** To Do, Research Phase, In Progress, Done

All progress will be tracked through:
- **GitHub Commit History** - each commit represents a discrete unit of work, with change messages describing what was changed and why
- **GitHub Projects Board** - tasks / issues are created per component and moved through the workflow as development progresses