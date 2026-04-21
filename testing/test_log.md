# Test Log

## 1. Unit Tests

Run with `pytest testing/` from the project root. Results recorded below after each run.

| Test ID | Function          | Scenario                          | Expected                 | Actual      | Pass/Fail |
|---------|-------------------|-----------------------------------|--------------------------|-------------|-----------|
| UT-01   | normalise_date    | Valid date "2025-03-15"           | datetime(2025, 3, 15)    | As Expected | Pass      |
| UT-02   | normalise_date    | Invalid day "2025-03-32"          | None                     | As Expected | Pass      |
| UT-03   | normalise_date    | Invalid month "2025-13-01"        | None                     | As Expected | Pass      |
| UT-04   | normalise_date    | Wrong format "15/03/2025"         | None                     | As Expected | Pass      |
| UT-05   | normalise_date    | No separator "20250315"           | None                     | As Expected | Pass      |
| UT-06   | normalise_date    | Text input "not-a-date"           | None                     | As Expected | Pass      |
| UT-07   | normalise_date    | Empty string ""                   | None                     | As Expected | Pass      |
| UT-08   | normalise_time    | Valid time "14:30"                | datetime(1900,1,1,14,30) | As Expected | Pass      |
| UT-09   | normalise_time    | Midnight "00:00"                  | datetime(1900,1,1,0,0)   | As Expected | Pass      |
| UT-10   | normalise_time    | End of day "23:59"                | datetime(1900,1,1,23,59) | As Expected | Pass      |
| UT-11   | normalise_time    | Invalid hour "25:00"              | None                     | As Expected | Pass      |
| UT-12   | normalise_time    | Invalid minute "12:60"            | None                     | As Expected | Pass      |
| UT-13   | normalise_time    | AM/PM format "2:30pm"             | None                     | As Expected | Pass      |
| UT-14   | normalise_time    | Empty string ""                   | None                     | As Expected | Pass      |
| UT-15   | normalise_number  | Valid positive "5"                | 5                        | As Expected | Pass      |
| UT-16   | normalise_number  | Zero with positive_only=True      | None                     | As Expected | Pass      |
| UT-17   | normalise_number  | Zero with positive_only=False     | 0                        | As Expected | Pass      |
| UT-18   | normalise_number  | Negative with positive_only=True  | None                     | As Expected | Pass      |
| UT-19   | normalise_number  | Negative with positive_only=False | -1                       | As Expected | Pass      |
| UT-20   | normalise_number  | Non-numeric "abc"                 | None                     | As Expected | Pass      |
| UT-21   | normalise_number  | Float string "3.5"                | None                     | As Expected | Pass      |
| UT-22   | normalise_number  | Large number "9999"               | 9999                     | As Expected | Pass      |
| UT-23   | normalise_weather | Lowercase "sunny"                 | "Sunny"                  | As Expected | Pass      |
| UT-24   | normalise_weather | Uppercase "CLOUDY"                | "Cloudy"                 | As Expected | Pass      |
| UT-25   | normalise_weather | Multi-word "light rain"           | "Light Rain"             | As Expected | Pass      |
| UT-26   | normalise_weather | Invalid "tornado"                 | None                     | As Expected | Pass      |
| UT-27   | normalise_weather | Empty string ""                   | None                     | As Expected | Pass      |
| UT-28   | normalise_boolean | "y"                               | True                     | As Expected | Pass      |
| UT-29   | normalise_boolean | "yes"                             | True                     | As Expected | Pass      |
| UT-30   | normalise_boolean | "true"                            | True                     | As Expected | Pass      |
| UT-31   | normalise_boolean | "1"                               | True                     | As Expected | Pass      |
| UT-32   | normalise_boolean | "n"                               | False                    | As Expected | Pass      |
| UT-33   | normalise_boolean | "no"                              | False                    | As Expected | Pass      |
| UT-34   | normalise_boolean | "false"                           | False                    | As Expected | Pass      |
| UT-35   | normalise_boolean | "0"                               | False                    | As Expected | Pass      |
| UT-36   | normalise_boolean | Uppercase "YES"                   | True                     | As Expected | Pass      |
| UT-37   | normalise_boolean | Uppercase "NO"                    | False                    | As Expected | Pass      |
| UT-38   | normalise_boolean | Invalid "maybe"                   | None                     | As Expected | Pass      |
| UT-39   | normalise_boolean | Empty string ""                   | None                     | As Expected | Pass      |

---

## 2. Manual Pipeline Tests

### 2.1 CSV Ingestion

| Test ID | Description               | Input                                    | Expected Result                                 | Actual Result | Pass/Fail |
|---------|---------------------------|------------------------------------------|-------------------------------------------------|---------------|-----------|
| MT-01   | Valid CSV ingested        | sample_sightings.csv (all valid rows)    | All rows inserted, success logged               | As expected   | Pass      |
| MT-02   | Missing required column   | CSV missing `species_name` column        | File rejected, error logged                     | As expected   | Pass      |
| MT-03   | Invalid date in row       | Row with session_date "32-13-2025"       | Row rejected, warning logged, others inserted   | As expected   | Pass      |
| MT-04   | Invalid species           | Row with species not in Species table    | Row rejected, warning logged                    | As expected   | Pass      |
| MT-05   | Count of zero             | Row with count = 0                       | Row rejected, warning logged                    | As expected   | Pass      |
| MT-06   | Invalid weather condition | Row with weather "blizzard"              | Row rejected, warning logged                    | As expected   | Pass      |
| MT-07   | Invalid email format      | Row with email "notanemail"              | Row rejected, warning logged                    | As expected   | Pass      |
| MT-08   | Session reuse             | Two rows with same volunteer, site, date | Single session created, both sightings inserted | As expected   | Pass      |

### 2.2 JSON Ingestion

| Test ID | Description               | Input                                  | Expected Result                          | Actual Result | Pass/Fail |
|---------|---------------------------|----------------------------------------|------------------------------------------|---------------|-----------|
| MT-09   | Valid JSON ingested       | sample_sightings.json (all valid rows) | All rows inserted, success logged        | As expected   | Pass      |
| MT-10   | Invalid JSON syntax       | Malformed JSON file                    | Handled error on file load, error logged | As expected   | Pass      |
| MT-11   | Missing field in JSON row | Row missing `count` key                | Row rejected, warning logged             | As expected   | Pass      |

### 2.3 XML Ingestion

| Test ID | Description                   | Input                                  | Expected Result                   | Actual Result | Pass/Fail |
|---------|-------------------------------|----------------------------------------|-----------------------------------|---------------|-----------|
| MT-12   | Valid XML ingested            | sample_sightings.xml (schema-valid)    | All rows inserted, success logged | As expected   | Pass      |
| MT-13   | XML fails schema validation   | XML with missing required element      | File rejected, error logged       | As expected   | Pass      |
| MT-14   | XML with invalid field values | Schema-valid XML, invalid species name | Row rejected during validate_rows | As expected   | Pass      |

---

## 3. CRUD Testing

I have created and executed a series of tests below, ontop of the testing that was carried out when creating the tables themselves and inserting the data using the ingestion system.

View the database DDL creation in the [docs/database_ddl](/docs/database_ddl.sql) file.

### 3.1 Create (INSERT)

| Test ID | Operation                     | Query                                                                                                                                                                                          | Expected Result                                        | Actual Result | Pass/Fail |
|---------|-------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|---------------|-----------|
| CR-01   | INSERT new species            | `INSERT INTO Species (species_id, species_name, scientific_name, category, conservation_status, is_priority) VALUES ('SP_TEST01', 'Test Deer', 'Cervus testus', 'Mammal', 'Least Concern', 0)` | 1 row inserted                                         | As expected   | Pass      |
| CR-02   | INSERT new volunteer          | `INSERT INTO Volunteers (volunteer_id, first_name, last_name, email, phone, region, is_active) VALUES ('V_TEST01', 'Jane', 'Test', 'jane.test@example.com', '07700900001', 'Highlands', 1)`    | 1 row inserted                                         | As expected   | Pass      |
| CR-03   | INSERT session (trigger test) | `INSERT INTO Sessions (session_id, volunteer_id, site_id, date, start_time, end_time) VALUES ('', 'V_TEST01', (SELECT site_id FROM Sites LIMIT 1), '2025-06-01', '09:00:00', '11:00:00')`      | 1 row inserted, `session_id` auto-generated by trigger | As expected   | Pass      |

### 3.2 Read (SELECT)

| Test ID | Operation                                                               | Query                                                                                                                                                                                                                                                                                        | Expected Result                                      | Actual Result | Pass/Fail |
|---------|-------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|---------------|-----------|
| RD-01   | Get all sightings with site name and individual count (3x JOIN)         | `SELECT sg.sighting_id, sp.species_name, si.site_name, sg.individuals_count, se.date FROM Sightings sg JOIN Sessions se ON sg.session_id = se.session_id JOIN Sites si ON se.site_id = si.site_id JOIN Species sp ON sg.species_id = sp.species_id`                                          | All sightings returned with species and site names   | As expected   | Pass      |
| RD-02   | Sighting count per species (GROUP BY + aggregate)                       | `SELECT sp.species_name, COUNT(sg.sighting_id) AS sighting_count FROM Sightings sg JOIN Species sp ON sg.species_id = sp.species_id GROUP BY sp.species_name ORDER BY sighting_count DESC`                                                                                                   | One row per species with count, ordered descending   | As expected   | Pass      |
| RD-03   | Endangered species sightings (JOIN + WHERE)                             | `SELECT sg.sighting_id, sp.species_name, sp.conservation_status, sg.individuals_count, se.date FROM Sightings sg JOIN Species sp ON sg.species_id = sp.species_id JOIN Sessions se ON sg.session_id = se.session_id WHERE sp.conservation_status IN ('Endangered', 'Critically Endangered')` | Only sightings of endangered species returned        | As expected   | Pass      |
| RD-04   | Daily sighting trend (GROUP BY date + HAVING)                           | `SELECT se.date, COUNT(sg.sighting_id) AS sighting_count FROM Sightings sg JOIN Sessions se ON sg.session_id = se.session_id GROUP BY se.date HAVING sighting_count > 0 ORDER BY se.date`                                                                                                    | Sighting counts grouped by date                      | As expected   | Pass      |
| RD-05   | Species observed at multiple sites (GROUP BY + HAVING + COUNT DISTINCT) | `SELECT sp.species_name, COUNT(DISTINCT se.site_id) AS site_count FROM Sightings sg JOIN Sessions se ON sg.session_id = se.session_id JOIN Species sp ON sg.species_id = sp.species_id GROUP BY sp.species_id, sp.species_name HAVING COUNT(DISTINCT se.site_id) > 1`                        | Only species recorded at more than one site returned | As expected   | Pass      |

### 3.3 Update (UPDATE)

| Test ID | Operation                          | Query                                                                                    | Expected Result  | Actual Result | Pass/Fail |
|---------|------------------------------------|------------------------------------------------------------------------------------------|------------------|---------------|-----------|
| UP-01   | Update species conservation status | `UPDATE Species SET conservation_status = 'Endangered' WHERE species_name = 'Test Deer'` | 1 row affected   | As expected   | Pass      |
| UP-02   | Update volunteer email             | `UPDATE Volunteers SET email = 'updated@example.com' WHERE volunteer_id = 'V_TEST01'`    | 1 row affected   | As expected   | Pass      |

### 3.4 Delete (DELETE)

| Test ID | Operation                                                       | Query                                                | Expected Result                                            | Actual Result | Pass/Fail |
|---------|-----------------------------------------------------------------|------------------------------------------------------|------------------------------------------------------------|---------------|-----------|
| DL-01   | Delete test species (no FK)                                     | `DELETE FROM Species WHERE species_id = 'SP_TEST01'` | 1 row deleted                                              | As expected   | Pass      |
| DL-02   | Delete species referenced by existing sightings (FK constraint) | `DELETE FROM Species WHERE species_name = 'Osprey'`  | SQL Error (1451): Cannot delete or update a parent row...  | As expected   | Pass      |

### 3.5 Stored Procedure (`identify_population_trend`)

| Test ID | Scenario                                      | Query                                                                         | Expected Result                                     | Actual Result | Pass/Fail |
|---------|-----------------------------------------------|-------------------------------------------------------------------------------|-----------------------------------------------------|---------------|-----------|
| SP-01   | Declining endangered species - alert inserted | `CALL identify_population_trend('Osprey', '2026-01-01', '2026-04-30')`        | Trend: Decreasing, alert inserted into Alerts table | As expected   | Pass      |
| SP-02   | Increasing species - no alert                 | `CALL identify_population_trend('Mountain Hare', '2026-01-01', '2026-04-30')` | Trend: Increasing, no alert inserted                | As expected   | Pass      |
| SP-03   | Species not in database - error raised        | `CALL identify_population_trend('Unicorn', '2026-01-01', '2026-04-30')`       | SQL Error (1644): Species not found                 | As expected   | Pass      |

---

## 4. API Tests

I tested the API manually by using [Bruno](https://www.usebruno.com/). The server was started with `npm run start:dev` from the `api/` directory. 

Then all tests were run against `http://localhost:3000` ensuring all the responses were as expected.

### 4.1 GET /report/site/:id

| Test ID | Scenario                    | Request                              | Expected                                                                 | Actual      | Pass/Fail |
|---------|-----------------------------|--------------------------------------|--------------------------------------------------------------------------|-------------|-----------|
| AT-01   | Valid site ID               | `GET /report/site/ST-0001`           | 200 JSON with site fields, nested sessions, sightings, and species data  | As expected | Pass      |
| AT-02   | Site ID does not exist      | `GET /report/site/INVALID_SITE_1023` | 404 with message "Site INVALID_SITE_1023 not found"                      | As expected | Pass      |

### 4.2 GET /report/alerts

| Test ID | Scenario                    | Request                          | Expected                                                                 | Actual      | Pass/Fail |
|---------|-----------------------------|----------------------------------|--------------------------------------------------------------------------|-------------|-----------|
| AT-03   | Alerts exist in database    | `GET /report/alerts`             | 200 with `Content-Type: application/xml`, well-formed XML document       | As expected | Pass      |
| AT-04   | XML passes XSD validation   | `GET /report/alerts`             | Response XML validates against `alerts.xsd` without error                | As expected | Pass      |
