USE f1_db;

-- Analysis 03: Pit Stop Consistency by Constructor
-- Comparing average recorded pit stop duration and variation

-- Business question:
-- Which Formula 1 constructors were the most consistent in recorded pit stop
-- duration, based on standard deviation?

-- Dataset coverage note:
-- The full F1 dataset covers seasons from 1950 to 2024.
-- However, the pit_stops table only contains recorded pit stop data from 2011 onwards.
-- Therefore, this pit stop consistency analysis covers 2011 to 2024.

-- Why this matters:
-- A fast average pit stop time is useful, but consistency is also important.
-- A constructor with low variation is more predictable operationally, which can
-- support better race strategy and reduce the risk of time loss.

SELECT
    c.name AS constructor_name,                                           -- Team name
    COUNT(*) AS total_pit_stops,                                          -- Number of pit stops analysed
    MIN(ra.year) AS first_season_in_data,                                 -- First season included
    MAX(ra.year) AS latest_season_in_data,                                -- Latest season included
    ROUND(AVG(ps.milliseconds) / 1000, 2) AS avg_pit_stop_seconds,        -- Average recorded pit stop duration
    ROUND(STDDEV(ps.milliseconds) / 1000, 2) AS pit_stop_stddev_seconds,  -- Variation around the average
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
    AND ps.milliseconds BETWEEN 10000 AND 60000
GROUP BY
    c.constructorId,
    c.name
HAVING COUNT(*) >= 50
ORDER BY
    pit_stop_stddev_seconds ASC,
    avg_pit_stop_seconds ASC
LIMIT 10;