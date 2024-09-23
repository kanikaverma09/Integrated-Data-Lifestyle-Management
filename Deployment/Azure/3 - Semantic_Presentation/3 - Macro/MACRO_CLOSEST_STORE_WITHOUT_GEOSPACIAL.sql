REPLACE MACRO Find_Closest_Store (
given_store_id INTEGER
)
AS (
WITH GivenStore AS (
SELECT
City,
Latitude,
Longitude
FROM
AR186005.SEM_AZURE_RETAIL_STORE_VW
WHERE
Store_Id = :given_store_id

),
SameCityStores AS (
SELECT
s.Store_Id,
s.Store_Name,
s.Latitude,
s.Longitude,
-- Calculate distance using Haversine formula

6371 * ACOS(
COS(RADIANS(g.Latitude)) * COS(RADIANS(s.Latitude)) * COS(RADIANS(s.Longitude) - RADIANS(g.Longitude)) +
SIN(RADIANS(g.Latitude)) * SIN(RADIANS(s.Latitude))
) AS Distance
FROM
AR186005.SEM_AZURE_RETAIL_STORE_VW s
CROSS JOIN
GivenStore g
WHERE
s.Store_Id <> :given_store_id -- Exclude the given store itself
AND s.City = g.City -- Confine comparisons to stores within the same city
)
SELECT
Store_Id,
Store_Name,
Latitude,
Longitude,
Distance
FROM
SameCityStores
QUALIFY ROW_NUMBER() OVER (ORDER BY Distance) = 1;
);
