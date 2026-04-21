# Technical Report

## SQL vs NoSQL

### Relational (SQL)

Relational databases organise data into tables with defined schemas, primary keys, and enforced foreign key constraints. 

SQL databases provide ACID guarantees: every transaction is atomic, consistent, isolated, and durable. 

Complex multi-table queries are handled natively via JOINs, GROUP BY, and aggregate functions, and stored procedures can encapsulate business logic close to the data.

### Non-relational (NoSQL)

NoSQL databases (such as MongoDB, DynamoDB and Redis) store documents, key-value pairs, or graph structures which do not have a fixed schema. 

These databases are horizontally scalable, which allow for a variation of data shapes and are suited to high speed writes. 

A document store could hold a sighting as a self-contained JSON object with volunteer and species details embedded, avoiding JOINs at query time.

### Trade-offs and Justification for This Project

MySQL was chosen for this project for three reasons;

1. The data is strongly relational and should have a fixed structure. A sighting is meaningless without its associated session, volunteer, site, and species records. Enforcing these relationships via foreign keys at the database level prevents orphaned records and ensures data integrity which is essential when the data informs legal protection decisions for Critically Endangered species.

2. The stored procedure requires a multi-table JOIN across Sightings and Sessions grouped by date range. This is trivial in SQL and complex to replicate in most document stores.

3. Conservation data demands auditability and consistency. MySQL's ACID properties mean that a failed batch insert leaves no partial records.

A document store would have been appropriate if the pipeline needed to handle highly variable such as schemaless fields at scale.

For this project however, having a database with a fixed schema is more suited due to the correctness guarantees it provides.

---

## JSON vs XML

### JSON

JSON is a lightweight text-based format, with syntax derived from JavaScript object literals. JSON is compact and human-readable, and directly parseable in many programming languages without the need for external libraries. 

JSON is highly flexible and also supports nested structures natively but has no built-in schema validation standard.

### XML

XML is a verbose, tag-based format designed to be self-describing. Its primary advantage is strong schema validation via XSD or DTD, which can enforce element order and data types, before any application level processing occurs.

Parsing XML often requires dedicated libraries (such as `lxml`), but the schema validation step provides structural guarantees upfront.

### Trade-offs and Justification for This Project

Both formats are used in this project, each for a different reason.

JSON is used as one ingestion format and as the output format for the API. Its compactness reduces payload size for HTTP responses, and both Python and Node.js support it natively with no additional dependencies. 

XML is used as a second ingestion format with a validating XSD schema. The XSD check, performed via `lxml.etree.XMLSchema`, validates the document structure before any row-level processing begins. A file that does not conform to the schema is rejected entirely and logged.

In my opinion, JSON is preferable for API's due to its compactness and tooling support. XML is preferable when an agreed, fixed schema is required.

I'd still probably choose JSON over XML every time, and just implement my own schema validation, like I did in this project.