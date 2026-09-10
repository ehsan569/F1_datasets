USE f1_db;

-- Analysis 02: Rolling Average Pit Stop Duration
-- Red Bull vs Mercedes, 2020 Season

-- Business question:
-- Did Red Bull and Mercedes get faster or slower at recorded pit stop
-- durations as the 2020 season progressed?

-- Important note:
-- This analysis uses constructor-level pit stop records. During validation,
-- some Red Bull 2020 driverId values did not match the drivers table.
-- Therefore, driverId is used directly instead of joining to driver names.

SELECT
    ra.year AS season,                                                               -- F1 season
    ra.round AS race_round,                                                          -- Race order in the season
    ra.name AS race_name,                                                            -- Grand Prix name
    c.name AS constructor_name,                                                      -- Team name
    ps.driverId AS driver_id,                                                        -- Driver ID from pit stop table
    ps.stop AS stop_number,                                                          -- Stop number for that driver
    ps.lap AS pit_stop_lap,                                                          -- Lap when pit stop happened
    ROUND(ps.milliseconds / 1000, 2) AS pit_stop_seconds,                            -- Individual pit stop duration in seconds

    ROUND(
        AVG(ps.milliseconds) OVER (
            PARTITION BY c.name
            ORDER BY ra.round, ps.lap, ps.stop, ps.driverId
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / 1000, 2
    ) AS rolling_avg_pit_stop_seconds                                                -- Running average by constructor

FROM pit_stops AS ps
INNER JOIN results AS res
    ON ps.raceId = res.raceId
    AND ps.driverId = res.driverId
INNER JOIN constructors AS c
    ON res.constructorId = c.constructorId
INNER JOIN races AS ra
    ON ps.raceId = ra.raceId
WHERE ra.year = 2020
    AND c.name IN ('Red Bull', 'Mercedes')
    AND ps.milliseconds IS NOT NULL
    AND ps.milliseconds BETWEEN 10000 AND 60000
ORDER BY
    ra.round,
    c.name,
    ps.lap,
    ps.stop,
    ps.driverId;


-- Summary: First vs Final Rolling Average
-- This query summarises whether each constructor's rolling average
-- became faster or slower across the 2020 season.

WITH rolling_pit_stops AS (
    SELECT
        c.name AS constructor_name,                                                    -- Team name
        ra.round AS race_round,                                                        -- Race order in the season
        ra.name AS race_name,                                                          -- Grand Prix name
        ps.lap AS pit_stop_lap,                                                        -- Lap when pit stop happened
        ps.stop AS stop_number,                                                        -- Stop number for that driver
        ps.driverId AS driver_id,                                                      -- Driver ID from pit stop table
        ROUND(ps.milliseconds / 1000, 2) AS pit_stop_seconds,                          -- Individual stop duration

        ROUND(
            AVG(ps.milliseconds) OVER (
                PARTITION BY c.name
                ORDER BY ra.round, ps.lap, ps.stop, ps.driverId
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) / 1000, 2
        ) AS rolling_avg_pit_stop_seconds,                                             -- Running average by constructor

        ROW_NUMBER() OVER (
            PARTITION BY c.name
            ORDER BY ra.round, ps.lap, ps.stop, ps.driverId
        ) AS stop_sequence,                                                            -- Stop order within constructor season

        COUNT(*) OVER (
            PARTITION BY c.name
        ) AS total_constructor_stops                                                   -- Total 2020 stops for constructor

    FROM pit_stops AS ps
    INNER JOIN results AS res
        ON ps.raceId = res.raceId
        AND ps.driverId = res.driverId
    INNER JOIN constructors AS c
        ON res.constructorId = c.constructorId
    INNER JOIN races AS ra
        ON ps.raceId = ra.raceId
    WHERE ra.year = 2020
        AND c.name IN ('Red Bull', 'Mercedes')
        AND ps.milliseconds IS NOT NULL
        AND ps.milliseconds BETWEEN 10000 AND 60000
)

SELECT
    constructor_name,
    MAX(CASE WHEN stop_sequence = 1 THEN rolling_avg_pit_stop_seconds END) AS first_rolling_avg_seconds,
    MAX(CASE WHEN stop_sequence = total_constructor_stops THEN rolling_avg_pit_stop_seconds END) AS final_rolling_avg_seconds,
    ROUND(
        MAX(CASE WHEN stop_sequence = total_constructor_stops THEN rolling_avg_pit_stop_seconds END)
        -
        MAX(CASE WHEN stop_sequence = 1 THEN rolling_avg_pit_stop_seconds END),
        2
    ) AS change_in_rolling_avg_seconds
FROM rolling_pit_stops
GROUP BY
    constructor_name
ORDER BY
    constructor_name;