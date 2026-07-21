# F1 Race Performance Analysis using MySQL

## Project Overview

This project analyses Formula 1 race performance data using MySQL. The aim is to demonstrate SQL querying, data cleaning, exploratory analysis, and business-style insight generation for a data analyst portfolio.

The dataset used is the Formula 1 World Championship dataset from Kaggle, covering race data from 1950 to 2024.

## Tools Used

- MySQL Workbench
- VS Code
- GitHub
- Kaggle Formula 1 dataset

## Key SQL Analyses

### Analysis 01: Recorded Pit Stop Duration by Constructor

**Business question:**  
Which Formula 1 constructors achieved the lowest average recorded pit stop duration in the dataset?

**Tables used:**  
`pit_stops`, `results`, `constructors`, `races`

**SQL techniques used:**  
`INNER JOIN`, `GROUP BY`, `COUNT()`, `AVG()`, `MIN()`, `MAX()`, `ROUND()`, `HAVING`, filtering

This analysis compared constructors by their average recorded pit stop duration using the `pit_stops`, `results`, `constructors`, and `races` tables.

After filtering for valid pit stop durations between 10 and 60 seconds and requiring at least 50 recorded pit stops per constructor, **Red Bull ranked first** with the lowest average recorded pit stop duration of **23.41 seconds** across **924 pit stops** between **2011 and 2024**.

| Rank | Constructor | Avg recorded pit stop seconds | Total pit stops | Seasons |

| 1 | Red Bull | 23.41 | 924 | 2011–2024 |
| 2 | Lotus F1 | 23.65 | 173 | 2012–2015 |
| 3 | Ferrari | 23.67 | 892 | 2011–2024 |
| 4 | Mercedes | 23.69 | 925 | 2011–2024 |
| 5 | McLaren | 23.78 | 663 | 2011–2024 |

Ferrari, Mercedes, and McLaren also appeared in the top five, suggesting that leading constructors generally maintained strong pit stop operational performance across multiple seasons.

**Important limitation:**  
The dataset appears to record broader pit stop event duration rather than the official stationary tyre-change time shown during Formula 1 broadcasts. Therefore, the results should be interpreted as relative pit stop duration performance within the dataset, not official tyre-change rankings.


### Analysis 02: Rolling Average Pit Stop Trend — Red Bull vs Mercedes, 2020

**Business question:**  
Did Red Bull and Mercedes get faster or slower at recorded pit stop durations as the 2020 season progressed?

**Tables used:**  
`pit_stops`, `results`, `constructors`, `races`

**SQL techniques used:**  
`AVG() OVER`, `PARTITION BY`, `ORDER BY`, `ROWS BETWEEN`, `CTE`, `ROW_NUMBER()`, `COUNT() OVER`, conditional aggregation

This analysis used a rolling average to compare how recorded pit stop duration changed throughout the 2020 season for Red Bull and Mercedes. The rolling average was calculated separately for each constructor using `PARTITION BY`, with pit stops ordered by race round, lap, stop number, and driver ID.

| Constructor | First rolling average seconds | Final rolling average seconds | Change |
|---|---:|---:|---:|
| Mercedes | 21.85 | 25.27 | +3.42 |
| Red Bull | 20.94 | 24.76 | +3.82 |

The results show that both constructors had higher final rolling averages than their first recorded rolling averages. Mercedes increased from **21.85 seconds** to **25.27 seconds**, while Red Bull increased from **20.94 seconds** to **24.76 seconds**.

This suggests that, within the dataset, both teams’ recorded pit stop durations became slower on average as the 2020 season progressed. Red Bull started with a lower recorded pit stop duration than Mercedes and also ended with a lower final rolling average, but both teams followed an upward trend.

**Important limitation:**  
During validation, a data integrity issue was identified where some Red Bull 2020 `driverId` values did not match records in the `drivers` table. To avoid excluding valid Red Bull pit stop records, this analysis focused on constructor-level trends and used `driverId` directly instead of joining to driver names.