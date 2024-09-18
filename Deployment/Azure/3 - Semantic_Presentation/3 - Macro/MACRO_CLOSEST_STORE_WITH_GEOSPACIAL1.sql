REPLACE MACRO Find_Closest_Store (
given_store_id INTEGER
)
AS (
WITH GivenStore AS (
SELECT
Store_Id  as Given_store_id,
City,
Geospatial_point
FROM
KV255007.CORE_AZURE_RETAIL_STORE_VW
WHERE
Store_Id = :given_store_id
),
SameCityStores AS (
SELECT
g.Given_store_id,
s.Store_Id,
s.Store_Name,
s.Latitude,
s.Longitude,
s.Geospatial_point AS Location1
,g.Geospatial_point AS Location2,
Location1.ST_SphericalDistance(Location2)AS Distance 
FROM
KV255007.SEM_AZURE_RETAIL_STORE_VW s
CROSS JOIN
GivenStore g
WHERE
s.Store_Id <> :given_store_id -- Exclude the given store itself
AND s.City = g.City -- Confine comparisons to stores within the same city
)
SELECT
Store_Id|| ' is the nearest store for given input store'||trim(given_store_id) ||'-'|| Store_Name as Store_Id ,
Location1 As Geospacial_point,
Distance
FROM
SameCityStores
QUALIFY ROW_NUMBER() OVER (ORDER BY Distance) = 1;
);
