# Project Components

## Component 1 - Database Layer
*Modules: UI107005 A1 + UI107004 A1*

- **Schema:** ER diagram covering `Volunteers`, `Sites`, `Species`, `Sessions`, `Sightings`, and `Alerts`, normalised to 3NF with each step documented
- **Data:** 50+ records auto-populated by the pipeline from sighting files
- **Queries (10+):** species frequency by site, volunteer activity rankings, seasonal trends, endangered species sightings, sites with declining populations, and more
- **Indexes (2+):** with `EXPLAIN` justification, e.g. a composite index on `species + sighting_date` for trend queries
- **Stored procedure:** accepts a `species_name` and date range, calculates population trend (`increasing`, `decreasing`, or `stable` based on sighting counts), and automatically inserts an alert record when the species is endangered and declining

---

## Component 2 - Algorithms and Data Structures
*Modules: UI107001 A1 + A2 - submitted separately*

| Structure / Algorithm           | Purpose                                                                                                                                                                                     |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Hash map** (custom)           | O(1) species lookup index during CSV ingestion, validating that a species exists in reference data. Implements insertion, search, deletion, and collision handling                          |
| **Binary search tree** (custom) | Stores sighting records ordered by date for efficient range queries (e.g. all sightings between March and June 2025). Implements insertion, search, in-order traversal, and range retrieval |
| **Merge sort** (custom)         | Sorts sighting records by multiple criteria (e.g. species then count descending) for report generation, and sorts volunteer leaderboards                                                    |
| **Binary search**               | Efficient lookups on sorted species lists; BST search handles date-range queries                                                                                                            |
| **Unit tests**                  | Full suite for all four, covering edge cases including empty structures, single element, duplicates, and worst-case inputs                                                                  |

---

## Component 3 - Data Pipeline and Exchange
*Modules: UI107004 A1 + A2 + UI107006 A4*

- **CSV / JSON / XML Ingestion (Python):** Watches a folder for new files. For each file it validates headers, validates every row (date format, species exists, count is positive, site exists), rejects invalid rows with a logged warning, and inserts valid rows into the database
- **JSON Report Generation (Node.js):** Connects to the database, queries all sightings at a given site, and produces a structured JSON report with nested sighting records, served via `GET /report/site/:id`
- **XML Report Generation:** Generates a well-formed XML report of endangered species alerts with a validating schema (XSD or DTD), including site details, species, trend data, and recommended actions as nested elements
- **XML Parsing (Python):** Imports partner survey data supplied as XML, extracts site name, species observed, and observation counts, then inserts into the database

---

## Component 4 - Documentation
*All modules*

- Agile project plan
- System design diagrams
- Comprehensive security review
- Technical report with Big-O analysis and trade-off comparisons
- Sustainability statement

