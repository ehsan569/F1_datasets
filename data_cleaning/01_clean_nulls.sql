-- Clean \N string values from the F1 dataset
-- We only update the rows where the text is exactly '\N'

-- 1. Cleaning fastestLapTime column
UPDATE results
SET fastestLapTime = NULL
WHERE fastestLapTime = '\\N';

-- 2. Cleaning the pit_stops duration column
UPDATE pit_stops
SET duration = NULL
WHERE duration = '\\N';

-- 3. Cleaning the grid column
UPDATE results
SET grid = NULL
WHERE grid = '\\N';

-- 4. Cleaning the positionOrder column
UPDATE results
SET positionOrder = NULL
WHERE positionOrder = '\\N';