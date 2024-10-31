-- zadanie 1 
CREATE TEMP TABLE temp_buildings_changes AS
SELECT 
    b2018.polygon_id AS id_2018,
    b2019.polygon_id AS id_2019,
    b2018.geom AS geom_2018,
    b2019.geom AS geom_2019
FROM buildings_2018 b2018
RIGHT JOIN  buildings_2019 b2019 ON b2018.polygon_id = b2019.polygon_id
WHERE b2018.polygon_id IS NULL -- nowe budynki 
UNION ALL 
SELECT 
    b2018.polygon_id AS id_2018,
    b2019.polygon_id AS id_2019,
    b2018.geom AS geom_2018,
    b2019.geom AS geom_2019
FROM buildings_2018 b2018
RIGHT JOIN  buildings_2019 b2019 ON b2018.polygon_id = b2019.polygon_id
WHERE (NOT ST_Equals(b2019.geom, b2018.geom)) -- zmiana geometrii lub wysokości
	   OR  b2019.height <> b2018.height;

-- zadanie 2 

WITH buffer AS(
SELECT ST_Buffer(geom_2019, 0.005) as geom_with_buffer
FROM temp_buildings_changes
),
new_poi AS(
SELECT 
    p2018.poi_id AS id_2018,
    p2019.poi_id AS id_2019,
    p2018.geom AS geom_2018,
    p2019.geom AS geom_2019,
	p2019.type AS type 
FROM poi_2018 p2018
RIGHT JOIN  poi_2019 p2019 ON p2018.poi_id = p2019.poi_id
WHERE p2018.poi_id IS NULL -- nowe punkty 
),
count_poi AS(
SELECT SUM(
			CASE WHEN ST_intersects(b.geom_with_buffer, p.geom_2019) THEN 1 
			ELSE 0 END ) as poi_count, p.type
FROM new_poi p
CROSS JOIN buffer b
GROUP BY p.type
)
SELECT *
FROM count_poi
WHERE poi_count <> 0;


-- zadanie 3 
CREATE TABLE streets_reprojected AS
SELECT gid, link_id, st_name, ref_in_id, nref_in_id, 
	   func_class, speed_cat, fr_speed_l, to_speed_l,
	   dir_travel, ST_SetSRID(geom, 3068) as geom
FROM streets_2019;

SELECT * FROM streets_reprojected;


-- zadanie 4 

CREATE TABLE input_points (
	id INT,
	geometry GEOMETRY
);

INSERT INTO input_points (id, geometry)
VALUES (1, 'POINT(8.36093  49.03174)'),
	   (2, 'POINT(8.39876 49.00644)');

-- zadanie 5 

UPDATE input_points
SET geometry = ST_SetSRID(geometry, 3068);


-- zadanie 6 

WITH reprojected AS
(
	SELECT gid, node_id, link_id, point_num, z_level, "intersect",
		   lat,lon, ST_SetSRID(geom, 3068) as geom 
	FROM  streets_node_2019
), buffer AS
(
	SELECT ST_Buffer(ST_MakeLine(geometry), 0.002) as geometry 
	FROM input_points 
)
SELECT  *
FROM reprojected as s 
CROSS JOIN buffer as b 
WHERE  ST_intersects(b.geometry, s.geom);

-- zadanie 7 

WITH buffer AS
(
	SELECT ST_Buffer(geom, 0.003) AS geom
	FROM land_use_a_2019
	WHERE type = 'Park (City/County)'
), sport_store AS
(
SELECT * 
FROM poi_2019
WHERE type = 'Sporting Goods Store'
)
SELECT COUNT(*)
FROM  buffer as b 
CROSS JOIN sport_store as s 
WHERE ST_intersects(b.geom, s.geom);


-- zadanie 8 

CREATE TABLE T2019_KAR_BRIDGES AS
SELECT  ST_intersection(r.geom, w.geom)
FROM railways_2019 as r 
INNER JOIN  water_lines_2019 as w ON ST_intersects(r.geom, w.geom);
