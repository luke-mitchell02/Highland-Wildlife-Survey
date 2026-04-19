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

| Test ID | Description               | Input                                  | Expected Result                   | Actual Result                                                                      | Pass/Fail |
|---------|---------------------------|----------------------------------------|-----------------------------------|------------------------------------------------------------------------------------|-----------|
| MT-09   | Valid JSON ingested       | sample_sightings.json (all valid rows) | All rows inserted, success logged | As expected                                                                        | Pass      |
| MT-10   | Invalid JSON syntax       | Malformed JSON file                    | Error on parse, nothing inserted  | json.decoder.JSONDecodeError: Expecting ',' delimiter: line 16 column 3 (char 378) | Fail      |
| MT-11   | Missing field in JSON row | Row missing `count` key                | Row rejected, warning logged      | As expected                                                                        | Pass      |

### 2.3 XML Ingestion

| Test ID | Description                   | Input                                  | Expected Result                   | Actual Result | Pass/Fail |
|---------|-------------------------------|----------------------------------------|-----------------------------------|---------------|-----------|
| MT-12   | Valid XML ingested            | sample_sightings.xml (schema-valid)    | All rows inserted, success logged | As expected   | Pass      |
| MT-13   | XML fails schema validation   | XML with missing required element      | File rejected, error logged       | As expected   | Pass      |
| MT-14   | XML with invalid field values | Schema-valid XML, invalid species name | Row rejected during validate_rows | As expected   | Pass      |

---

## 3. CRUD Testing

### 3.1 Create (INSERT)

| Test ID | Operation | Query / Action | Expected Result | Actual Result | Pass/Fail |
|---------|-----------|----------------|-----------------|---------------|-----------|
| CR-01   | -         | -              | -               | -             | -         |

### 3.2 Read (SELECT)

| Test ID | Operation                        | Query / Action                                         | Expected Result                            | Actual Result | Pass/Fail |
|---------|----------------------------------|--------------------------------------------------------|--------------------------------------------|---------------|-----------|
| RD-01   | -                                | -                                                      | -                                          | -             | -         |

### 3.3 Update (UPDATE)

| Test ID | Operation | Query / Action | Expected Result | Actual Result | Pass/Fail |
|---------|-----------|----------------|-----------------|---------------|-----------|
| UP-01   | -         | -              | -               | -             | -         |


### 3.4 Delete (DELETE)

| Test ID | Operation | Query / Action | Expected Result | Actual Result | Pass/Fail |
|---------|-----------|----------------|-----------------|---------------|-----------|
| DL-01   | -         | -              | -               | -             | -         |

---

## 4. Error Handling Tests

| Test ID | Scenario | Action | Expected Result | Actual Result | Pass/Fail |
|---------|----------|--------|-----------------|---------------|-----------|
| EH-01   | -        | -      | -               | -             | -         |