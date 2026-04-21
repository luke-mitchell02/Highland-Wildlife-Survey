# Security and Sustainability Statement

## Security

In this project, there are very limited security controls, due to time constraints and scope creep.

Throughout the project, every database interaction, from volunteer lookup, site verification, species lookup, session creation, and sighting insert all passes their values as bound parameters via `%s` placeholder syntax. This eliminates the possibility of SQL injection at the point where all untrusted data enters the system: the CSV, JSON, and XML files dropped by field volunteers.

Credential isolation is enforced by storing the MySQL connection string in a `.env` file which is excluded from version control via `.gitignore`. No credentials are hardcoded into the application directly. This means the repository can be publicly exposed without the worry of the database credentials being leaked.

An input validation layer has been implemented as a second line of defence. Before any row reaches the database, the pipeline checks field lengths and validates all other values are valid values. Rows that fail any check are logged and discarded, this ensures malformed or malicious data never reaches the database.

As mentioned previously, there is very little security in terms of authorisation and authentication implemented into this project.

## Sustainability

Three design decisions directly reduce the resource cost of the system.

1. Database connections are recycled where possible, and batch update / inserts are completed where possible. Both of these things reduce the round trips necessary, which decreases both CPU time and network overhead compared to a row-by-row approach.

2. The watchdog daemon is event-driven rather than polling. The `Observer` class fires a callback only when a file is created in the monitoring directory. The pipeline sleeps until an event occurs and consumes negligible CPU between file arrivals. A polling alternative checking the directory every second would consume continuous CPU time even when no data was present.

3. The normalised schema (3NF) ensures that species information, site metadata, and volunteer details are each stored once and referenced by ID. Storing sightings without normalisation would require repeating species and site attributes in every row, increasing storage requirements and making bulk updates error-prone. Normalisation keeps the dataset compact.