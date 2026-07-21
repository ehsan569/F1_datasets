USE f1_db;

-- Data Cleaning: Replace invalid '\N' string values with NULL
-- This script documents the cleaning approach used for the F1 dataset.
-- Important:
-- Text-based '\N' cleaning should only be applied to columns imported as text.
-- Numeric columns such as grid and positionOrder should not be compared to '\N'.

-- 1. Cleaning fastestLapTime column
-- fastestLapTime may contain '\N' where no fastest lap time was recorded.
-- MySQL Safe Update Mode may block this update unless a key column is used
-- or Safe Update Mode is disabled intentionally.

-- UPDATE results
-- SET fastestLapTime = NULL
-- WHERE fastestLapTime = '\\N';

-- 2. Cleaning pit_stops duration column
-- DESCRIBE pit_stops showed duration is DOUBLE, so this update is not required.

-- UPDATE pit_stops
-- SET duration = NULL
-- WHERE duration = '\\N';

-- 3. Cleaning grid column
-- grid is numeric, so this update is not required.

-- UPDATE results
-- SET grid = NULL
-- WHERE grid = '\\N';

-- 4. Cleaning positionOrder column
-- positionOrder is numeric and caused Error Code 1292 when compared to '\N',
-- so this update is not required.

-- UPDATE results
-- SET positionOrder = NULL
-- WHERE positionOrder = '\\N';