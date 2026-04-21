# Security Review

## 1. Authentication

- Database credentials are stored in `.env` files which are excluded from commits using the `.gitignore`
- No user-facing authentication is currently implemented in the pipeline
- The NestJS API does not have any authentication

**Ways to Improve**

- Bearer token authentication could be implemented on the API to ensure only authorised clients can retrieve data

---

## 2. Authorisation

- The pipeline currently runs with a single database user with full access
- The reports API serves read-only data and has no write operations

**Ways to Improve**

- The database user should have restricted privileges to access only what they need
- Role based access could be combined with the bearer authentication token layer to more tightly control who can access what endpoints, regardless of having a valid token

---

## 3. Data Anonymity

- The volunteer records contain `first_name`, `last_name`, and `email` which is all personally identifiable information
- Data is held in a private MySQL database, which is not exposed publicly and not visible to the internet
- No anonymisation or pseudonymisation is applied currently

**Ways to Improve**

- The API should reveal `_id` only in JSON responses, which would protect users details being revealed
- Phone numbers are nullable in the `Volunteers` schema and should only be collected if actually required
- Anonymisation or pseudonymisation could be applied.

---

## 4. Data Destruction

- No automated data retention or deletion policy is implemented
- Records persist in the database indefinitely once inserted

**Ways to Improve**

- A retention policy should be defined: raw sighting records retained for seven years to support longitudinal conservation analysis, then archived or deleted
- The option for a volunteer to 'be forgotten' should be present. Their data could be deactivated automatically using a stored procedure and an API endpoint.
- On deactivation, personal data fields (first_name, last_name, email, phone) could be nulled while retaining the `volunteer_id` foreign key so that historic data remains intact

---

## 5. Lifecycle Security

- Dependencies are pinned in `requirements.txt` to prevent supply chain drift
- The `.env` file is excluded from version control
- No CI/CD pipeline is currently configured so deployments are manual

**Ways to Improve**

- `pip-audit` (Python) and `npm audit` (Node.js) should be run before each release to check for known CVEs in dependencies

---

## SQL Injection

The pipeline uses parameterised queries throughout to remove the risk of SQL Injection. Raw string interpolation is never used in any database query.

---

## Input Validation as a Security Measure

All incoming data is validated before it touches the database. 

The `build_schema` method in `main.py` defines length bounds and a normaliser function for every one of the 13 expected fields. 

Any row that fails a check is logged and discarded.

---

## Insider Threat

This pipeline operates in a safety-critical context, similar to CNI monitoring systems and IoT sensor networks, where tampered data can suppress a legitimate alert. 

Here, the consequences are ecological rather than financial where falsified sighting records could directly influence government protection decisions for Critically Endangered species.

Below I discuss the potential impacts an insider could have, and ways to mitigate them.

**What an insider could do:**
- A volunteer could submit fabricated sightings to inflate or suppress population counts
- A staff member could leak OS grid references of sensitive nesting sites (e.g. Speyside Wetland Centre, NH294837) to wildlife criminals
- An administrator with direct database access could delete rows from the Alerts table to conceal a genuine population decline

**Potential damage:**
The `identify_population_trend` stored procedure makes alert decisions based on sighting totals. Manipulated data could cause it to suppress an alert for a endangered species, leading to the withdrawal of protection for a species that genuinely needs it. 

There is currently no audit trail, so tampering with the database would leave no evidence.

**Mitigations:**
- Maintain a database audit log recording every INSERT, UPDATE, and DELETE on Sightings and Alerts, including the database user and timestamp
- Restrict direct database access to named administrators only; volunteers submit data exclusively through the ingestion pipeline
- Implement an event that checks outlier sightings and flags them for review before the trend procedure can process them and generate an alert
- Implement ingestion authentication that requires a token or password input which is unique to each volunteer