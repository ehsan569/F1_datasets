# Data Architecture: F1 Relational Database

## Core Schema
To perform operational analytics, this project relies on a central fact table (`results.csv`) bridging several dimension tables. Understanding these relationships is critical for writing accurate, multi-layered SQL joins.

![F1 Database Schema](F1_datasets_erd.png)

* **Fact Table:** `results` (race outcomes, fastest laps, grid positions)
* **Dimension Tables:**
  * `races` (date, year, circuit ID)
  * `drivers` (driver details, nationality)
  * `constructors` (team details)
  * `pit_stops` (duration, lap number)