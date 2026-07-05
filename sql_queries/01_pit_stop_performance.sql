USE f1_db;

-- Analysis 01: Pit Stop Performance by Constructor

-- Business question:
-- Which Formula 1 constructors achieved the fastest average pit
-- stop times in the available pit stop dataset?
--
-- Why this matters:
-- Pit stop efficiency is an important operational performance
-- factor in Formula 1. Faster pit stops can reduce time loss and
-- help drivers gain or protect track position during a race.
--
-- Tables used:
-- pit_stops     = pit stop duration data
-- results       = links drivers to constructors for each race
-- constructors  = team / constructor names
-- races         = race year information


SELECT
    c.name AS constructor_name,                                      -- Team name
    COUNT(*) AS total_pit_stops,                                     -- Number of pit stops analysed
    MIN(ra.year) AS first_season_in_data,                            -- First year included for this team
    MAX(ra.year) AS latest_season_in_data,                           -- Latest year included for this team
    ROUND(AVG(ps.milliseconds) / 1000, 2) AS avg_pit_stop_seconds,   -- Average stop time in seconds
    ROUND(MIN(ps.milliseconds) / 1000, 2) AS fastest_pit_stop_seconds,
    ROUND(MAX(ps.milliseconds) / 1000, 2) AS slowest_pit_stop_seconds
FROM pit_stops AS ps
INNER JOIN results AS res
    ON ps.raceId = res.raceId
    AND ps.driverId = res.driverId
INNER JOIN constructors AS c
    ON res.constructorId = c.constructorId
INNER JOIN races AS ra
    ON ps.raceId = ra.raceId
WHERE ps.milliseconds IS NOT NULL
    AND ps.milliseconds BETWEEN 1000 AND 10000
GROUP BY
    c.constructorId,
    c.name
HAVING COUNT(*) >= 50
ORDER BY avg_pit_stop_seconds ASC
LIMIT 10;