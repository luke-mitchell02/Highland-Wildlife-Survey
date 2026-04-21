# Database Design

## Normalisation

### UNF

The starting point is a single flat table representing a wildlife sighting record as it might be collected from a volunteer submission, with no structure applied.

| first_name | last_name | Email                 | Phone       | Region     | Site_Name               | Species_Name     | Count | Date       | Time     | Weather | Photo_Submitted | Notes                                     |
|------------|-----------|-----------------------|-------------|------------|-------------------------|------------------|-------|------------|----------|---------|-----------------|-------------------------------------------|
| Eilidh     | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Speyside Wetland Centre | Red Squirrel     | 2     | 2025-03-15 | 09:15:00 | Clear   | 1               | Seen near birch woodland edge.            |
| Eilidh     | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Speyside Wetland Centre | Pine Marten      | 1     | 2025-03-15 | 18:20:00 | Clear   | 0               | Observed moving between trees at dusk.    |
| Eilidh     | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Lochaber Pine Reserve   | Scottish Wildcat | 1     | 2025-12-07 | 06:55:00 | Fog     | 0               | Possible brief sighting near forest edge. |
| Calum      | Ross      | c.ross@email.com      | NULL        | Cairngorms | Skye Coastal Watch      | Golden Eagle     | 1     | 2025-03-16 | 11:40:00 | Cloudy  | 1               | Adult bird soaring above tree line.       |
| Fiona      | Munro     | fiona.munro@email.com | 07700111223 | Moray      | Lochaber Pine Reserve   | Roe Deer         | 3     | 2025-04-03 | 07:35:00 | Fog     | 1               | Small group feeding near woodland edge.   |

**Issues identified:**
- There are no unique identifiers for each row.
- Data redundancy is clearly visible with the volunteers details repeating across multiple rows.

---

### 1NF

**Rule:** Every column must contain atomic (indivisible) values, and each row must be unique.

**Changes made:**
- Added a Sighting ID as a unique identifier

**Result:**

| sighting_id (PK) | first_name  | last_name | email                 | phone       | region     | site_name               | species_name     | count | date       | time     | weather | photo_submitted | notes                                     |
|------------------|-------------|-----------|-----------------------|-------------|------------|-------------------------|------------------|-------|------------|----------|---------|-----------------|-------------------------------------------|
| SI_0001          | Eilidh      | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Speyside Wetland Centre | Red Squirrel     | 2     | 2025-03-15 | 09:15:00 | Clear   | 1               | Seen near birch woodland edge.            |
| SI_0002          | Eilidh      | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Speyside Wetland Centre | Pine Marten      | 1     | 2025-03-15 | 18:20:00 | Clear   | 0               | Observed moving between trees at dusk.    |
| SI_0003          | Eilidh      | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | Lochaber Pine Reserve   | Scottish Wildcat | 1     | 2025-12-07 | 06:55:00 | Fog     | 0               | Possible brief sighting near forest edge. |
| SI_0004          | Calum       | Ross      | c.ross@email.com      | NULL        | Cairngorms | Skye Coastal Watch      | Golden Eagle     | 1     | 2025-03-16 | 11:40:00 | Cloudy  | 1               | Adult bird soaring above tree line.       |
| SI_0005          | Fiona       | Munro     | fiona.munro@email.com | 07700111223 | Moray      | Lochaber Pine Reserve   | Roe Deer         | 3     | 2025-04-03 | 07:35:00 | Fog     | 1               | Small group feeding near woodland edge.   |

---

### 2NF

**Rule:** Must be in 1NF, and every non-key attribute must depend on the whole primary key (no partial dependencies).

**Partial dependencies identified:**
- `first_name`, `last_name`, `email`, `phone`, `region` all depend only on the volunteer
- `site_name` depends only on the site
- `species_name` depends only on the species
- `date` depends only on the volunteer and site combination, not on any individual sighting

**Changes made:**
- Split volunteer, site, and species details into their own tables with unique identifiers
- Add a `survey_sessions` table to capture a volunteer's visit to a site, since the date of the outing depend on the session rather than on any individual sighting

**Tables produced:**

Volunteers Table

| volunteer_id (PK) | first_name | last_name | email                 | phone       | region     | date_joined | is_active |
|-------------------|-----------|-----------|-----------------------|-------------|------------|-------------|-----------|
| VT_0001           | Eilidh    | MacLeod   | eilidh.m@email.com    | NULL        | Highlands  | 2024-03-28  | 1         |
| VT_0002           | Calum     | Ross      | c.ross@email.com      | NULL        | Cairngorms | 2024-04-15  | 0         |
| VT_0003           | Fiona     | Munro     | fiona.munro@email.com | 07700111223 | Moray      | 2025-11-29  | 1         |

Sites Table

| site_id (PK) | site_name               | region     | grid_reference | habitat_type | access_difficulty | is_active |
|--------------|-------------------------|------------|----------------|--------------|-------------------|-----------|
| ST_0001      | Speyside Wetland Centre | Highlands  | HL294837       | Freshwater   | Easy              | 1         |
| ST_0002      | Lochaber Pine Reserve   | Highlands  | HL295934       | Woodland     | Moderate          | 1         |
| ST_0003      | Skye Coastal Watch      | Cairngorms | CG924856       | Coastal      | Moderate          | 1         |

Species Table

| species_id (PK) | species_name     | scientific_name     | category | conservation_status   | is_priority |
|-----------------|------------------|---------------------|----------|-----------------------|-------------|
| SP_0001         | Red Squirrel     | Sciurus vulgaris    | Mammal   | Endangered            | 1           |
| SP_0002         | Pine Marten      | Martes martes       | Mammal   | Least Concern         | 0           |
| SP_0003         | Scottish Wildcat | Felis silvestris    | Mammal   | Critically Endangered | 1           |
| SP_0004         | Golden Eagle     | Aquila chrysaetos   | Bird     | Least Concern         | 1           |
| SP_0005         | Roe Deer         | Capreolus capreolus | Mammal   | Least Concern         | 0           |

Survey Sessions Table

| session_id (PK) | volunteer_id (FK) | site_id (FK) | date       | start_time | end_time |
|-----------------|-------------------|--------------|------------|------------|----------|
| SS_0001         | VT_0001           | ST_0001      | 2025-03-15 | 09:00:00   | 19:00:00 |
| SS_0002         | VT_0001           | ST_0002      | 2025-12-07 | 06:30:00   | 08:00:00 |
| SS_0003         | VT_0002           | ST_0003      | 2025-03-16 | 11:00:00   | 13:00:00 |
| SS_0004         | VT_0003           | ST_0002      | 2025-04-03 | 07:00:00   | 09:00:00 |

Sightings Table

| sighting_id (PK) | session_id (FK) | species_id (FK) | count | sighting_time | weather | photo_submitted | notes                                     |
|------------------|-----------------|-----------------|-------|---------------|---------|-----------------|-------------------------------------------|
| SI_0001          | SS_0001         | SP_0001         | 2     | 09:15:00      | Clear   | 1               | Seen near birch woodland edge.            |
| SI_0002          | SS_0001         | SP_0002         | 1     | 18:20:00      | Clear   | 0               | Observed moving between trees at dusk.    |
| SI_0003          | SS_0002         | SP_0003         | 1     | 06:55:00      | Fog     | 0               | Possible brief sighting near forest edge. |
| SI_0004          | SS_0003         | SP_0004         | 1     | 11:40:00      | Cloudy  | 1               | Adult bird soaring above tree line.       |
| SI_0005          | SS_0004         | SP_0005         | 3     | 07:35:00      | Fog     | 1               | Small group feeding near woodland edge.   |

---

### 3NF

**Rule:** Must be in 2NF, and no non-key attribute should depend on another non-key attribute (no transitive dependencies).

**Transitive dependencies identified:**
- None. Each non-key column in every table depends directly on the primary key and nothing else.

**Changes made:**
- No changes required. The schema produced at 2NF already satisfies 3NF.

**Final tables:**

The four tables produced at 2NF are the final normalised schema: Volunteers, Sites, Species, and Sightings.

---

## Entity Relationship Diagram

```mermaid
erDiagram

Volunteers {
    varchar volunteer_id PK
    varchar first_name
    varchar last_name
    varchar email
    varchar phone
    varchar region
    datetime date_joined
    tinyint is_active
}

Sites {
    varchar site_id PK
    varchar site_name
    varchar region
    varchar grid_reference
    varchar habitat_type
    varchar access_difficulty
    tinyint is_active
}

Species {
    varchar species_id PK
    varchar species_name
    varchar scientific_name
    varchar category
    varchar conservation_status
    tinyint is_priority
}

Sessions {
    varchar session_id PK
    varchar volunteer_id FK
    varchar site_id FK
    date date
    time start_time
    time end_time
}

Sightings {
    varchar sighting_id PK
    varchar session_id FK
    varchar species_id FK
    int count
    time sighting_time
    enum weather
    tinyint photo_submitted
    longtext notes
}

Alerts {
    int alert_id PK
    varchar species_id FK
    enum trend_direction
    int count
    datetime generated_time
}

Volunteers ||--o{ Sessions : ""                                                                                                                                                                      
Sites ||--o{ Sessions : ""                                                                                                                                                                              
Sessions ||--o{ Sightings : ""                                                                                                                                                                       
Species ||--o{ Sightings : ""
Species ||--o{ Alerts : ""
```

---

## Triggers

Two `BEFORE INSERT` triggers have been added to auto-generate the formatted primary key for Sessions and Sightings. This means the application never needs to supply an ID manually.

**before_session_insert** - fires on every insert into `Sessions` and sets `session_id` to `SS_` followed by the next sequential four-digit number (e.g. `SS_0001`).

**before_sighting_insert** - fires on every insert into `Sightings` and sets `sighting_id` to `SI_` followed by the next sequential four-digit number (e.g. `SI_0001`).

Both triggers derive the next number by counting existing rows and adding one, then zero-padding to four digits with `LPAD`.

This may be updated in the future to use MAX() as counting rows is only useful if no rows are ever deleted.

---

## Stored Procedure

The `identify_population_trend` stored procedure accepts a species name and a date range, calculates whether the population is increasing, decreasing, or stable, and inserts an alert if the species is endangered and declining.

```sql
CALL identify_population_trend('Osprey', '2026-01-01', '2026-04-30');
```

### How it works

The procedure splits the provided date range in half and compares the total `individuals_count` from the first half against the second half.

1. **Species Identification** - retrieves the `species_id` and `conservation_status` from the Species table. Raises a `SQLSTATE 45000` error if the species name is not found.
2. **Date Midpoint Calculation** - uses `DATEDIFF` to find the halfway point of the date range.
3. **Sighting Count** - runs two queries which join `Sightings` to `Sessions`, one for each half of the range.
4. **Trend Identification** - compares the two counts:
   - Second half higher -> `Increasing`
   - Second half lower -> `Decreasing`
   - Equal -> `Stable`
5. **Alert** - If the species has a `conservation_status` of `Endangered` or `Critically Endangered` and the trend is `Decreasing`: insert a row into `Alerts` table.

The procedure also returns a result row showing the species name, trend, both half-counts, and whether an alert was inserted. This is mainly for debugging but also so an output is always visible when called manually.

---

## Indexes

Two indexes were added and tested using `EXPLAIN` to measure their impact on query performance.

### Index 1 - `Sessions.date`

This column is used a lot in the date range queries and inside the `identify_population_trend` stored procedure. Without an index, MySQL scans all session rows and filters by date afterwards.

```sql
CREATE INDEX idx_sessions_date ON Sessions(date);
```

**Query tested:**
```sql
EXPLAIN SELECT sg.sighting_id, sg.individuals_count
FROM Sightings sg
JOIN Sessions se ON sg.session_id = se.session_id
WHERE se.date BETWEEN '2026-01-01' AND '2026-04-30';
```

**Before:**

Before the index, MySQL used the composite `volunteer_id` unique index as a fallback scan, with only 11.11% of rows matching the date filter.

| table | type  | key           | key_len | rows | filtered | Extra                       |
|-------|-------|---------------|---------|------|----------|-----------------------------|
| se    | index | volunteer_id  | 135     | 28   | 11.11%   | Using where; Using index    |
| sg    | ref   | volunteer_idx | 66      | 7    | 100.00%  |                             |

**After:**

After adding `idx_sessions_date`, MySQL uses the correct index for the date range and `filtered` rises to 100%, meaning every row accessed matches the condition. 

The `key_len` also drops from 135 to 3, reflecting the smaller date index.

| table | type  | key               | key_len | rows | filtered | Extra                    |
|-------|-------|-------------------|---------|------|----------|--------------------------|
| se    | index | idx_sessions_date | 3       | 28   | 100.00%  | Using where; Using index |
| sg    | ref   | volunteer_idx     | 66      | 8    | 100.00%  |                          |

---

### Index 2 - `Species.conservation_status`

This column is used a lot in the endangered species filter query (RD-03) and the stored procedure alert condition. Without an index, MySQL performs a full table scan across all species rows and filters by conservation status afterwards.

```sql
CREATE INDEX idx_species_conservation ON Species(conservation_status);
```

**Query tested:**
```sql
EXPLAIN SELECT sg.sighting_id, sp.species_name, sp.conservation_status
FROM Sightings sg
JOIN Species sp ON sg.species_id = sp.species_id
WHERE sp.conservation_status IN ('Endangered', 'Critically Endangered');
```

**Before:**

Before the index, MySQL performed a full table scan (`type=ALL`) across all 100 species rows, with only 40% of rows matching the filter.

| table | type | key          | key_len | rows | filtered | Extra       |
|-------|------|--------------|---------|------|----------|-------------|
| sp    | ALL  | NULL         | NULL    | 100  | 40.00%   | Using where |
| sg    | ref  | species_name | 66      | 11   | 100.00%  | Using index |

**After:**

After adding `idx_species_conservation`, the scan type changed to `range`, meaning MySQL uses the index to jump directly to matching rows.

The rows examined dropped from 100 to 6, and `filtered` rose to 100% - every row accessed now matches the condition.

| table | type  | key                      | key_len | rows | filtered | Extra                 |
|-------|-------|--------------------------|---------|------|----------|-----------------------|
| sp    | range | idx_species_conservation | 1       | 6    | 100.00%  | Using index condition |
| sg    | ref   | species_name             | 66      | 11   | 100.00%  | Using index           |
