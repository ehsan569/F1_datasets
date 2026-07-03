--Analysing Average Pit Stop Times by Constructor (Team)
-- This query joins three separate tables to calculate team efficiency

SELECT 
    c.name AS team_name,
    ROUND(AVG(p.milliseconds) / 1000, 2) AS avg_pit_stop_seconds
FROM pit_stops p
JOIN results r 
    ON p.raceId = r.raceId 
    AND p.driverId = r.driverId
JOIN constructors c 
    ON r.constructorId = c.constructorId
GROUP BY c.name
ORDER BY avg_pit_stop_seconds ASC
LIMIT 10;