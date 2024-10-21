-- zadanie 1 - zainstalowano 

-- zadanie 2 
CREATE DATABASE bds_cs2;
SET search_path TO bds_cs2;

-- zadanie 3 
CREATE EXTENSION postgis;

-- zadanie 4 

CREATE TABLE roads (
	id INT,
	geometry GEOMETRY,
	name VARCHAR(50)
);

CREATE TABLE buildings (
	id INT,
	geometry GEOMETRY,
	name VARCHAR(50)
);

CREATE TABLE poi (
	id INT,
	geometry GEOMETRY,
	name VARCHAR(50)
);

-- zadanie 5 
INSERT INTO roads (id, name, geometry)
VALUES (1, 'RoadX', 'LINESTRING(0 4.5, 12 4.5)'),
	   (2, 'RoadY', 'LINESTRING(7.5 10.5, 7.5 0)');

INSERT INTO poi (id, name, geometry)
VALUES (1, 'K', 'POINT(6 9.5)'),
	   (2, 'I', 'POINT(9.5 6)'),
	   (3, 'J', 'POINT(6.5 6)'),
	   (4, 'G', 'POINT(1 3.5)'),
	   (5, 'H', 'POINT(5.5 1.5)');

INSERT INTO buildings (id, name, geometry)
VALUES (1, 'BuildingA', 'POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))'),
	   (2, 'BuildingB', 'POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))'),
	   (3, 'BuildingC', 'POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))'),
	   (4, 'BuildingD', 'POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))'),
	   (5, 'BuildingF', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');


-- zadanie 6 

-- a)
SELECT SUM(ST_LENGTH(geometry))
FROM roads;

-- b) 
SELECT ST_ASTEXT(geometry), ST_AREA(geometry), ST_PERIMETER(geometry)
FROM buildings
WHERE name = 'BuildingA';

-- c)
SELECT name, ST_AREA(geometry)
FROM buildings
ORDER BY name ASC;

-- d)
SELECT name, ST_PERIMETER(geometry)
FROM buildings
ORDER BY ST_AREA(geometry) DESC
LIMIT 2;

-- e)
SELECT ST_DISTANCE(b.geometry, p.geometry) 
FROM buildings as b
CROSS JOIN poi as p 
WHERE b.name = 'BuildingC' AND p.name = 'K';

-- f)
SELECT ST_Area(ST_Difference(bC.geometry, ST_Buffer(bB.geometry, 0.5)))
FROM buildings AS bC
CROSS JOIN buildings AS bB
WHERE bC.name = 'BuildingC' AND bB.name = 'BuildingB';

-- g)
SELECT b.name 
FROM buildings AS b
CROSS JOIN roads AS r
WHERE r.name = 'RoadX' AND ST_Y(ST_CENTROID(b.geometry)) > ST_Y(ST_CENTROID(r.geometry));

-- h) 
SELECT ST_AREA(ST_SYMDIFFERENCE(geometry, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
FROM buildings
WHERE name = 'BuildingC'
