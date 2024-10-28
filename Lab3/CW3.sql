-- zadanie 1 
CREATE TEMP TABLE temp_buildings_changes AS
SELECT 
    b2018.gid AS id_2018,
    b2019.gid AS id_2019,
    b2018.geom AS geom_2018,
    b2019.geom AS geom_2019
FROM buildings_2018 b2018
RIGHT JOIN  buildings_2019 b2019 ON b2018.gid = b2019.gid
WHERE b2018.gid IS NULL -- nowe budynki 
UNION ALL 
SELECT 
    b2018.gid AS id_2018,
    b2019.gid AS id_2019,
    b2018.geom AS geom_2018,
    b2019.geom AS geom_2019
FROM buildings_2018 b2018
RIGHT JOIN  buildings_2019 b2019 ON b2018.gid = b2019.gid
WHERE (NOT ST_Equals(b2019.geom, b2018.geom)) -- zmiana geometrii lub wysokości
	   OR  b2019.height <> b2018.height;

-- zadanie 2 

SELECT * FROM temp_buildings_changes;



-- zadanie 3 


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
SELECT * FROM input_points;


-- zadanie 6 

-- zadanie 7 

-- zadanie 8 
