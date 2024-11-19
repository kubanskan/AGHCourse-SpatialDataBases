SET search_path TO bds_cw5, public;
CREATE EXTENSION postgis SCHEMA public;


-- zadanie 1 
CREATE TABLE public.obiekty(
	id SERIAL,
	geometry GEOMETRY, 
	name VARCHAR(50)
);


INSERT INTO obiekty(name, geometry)
VALUES 
('obiekt1', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(0 1, 1 1)'),
				ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1, 4  2, 5 1)'),
				ST_GeomFromText('LINESTRING(5 1, 6 1)')]
		         )
), 

('obiekt2', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(10 6, 14 6)'),
				ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2)'),
				ST_GeomFromText('LINESTRING(10 2, 10 6)'),
				ST_GeomFromText('CIRCULARSTRING(11 2, 13 2, 11 2)')]
		        )
),

('obiekt3', ST_GeomFromText('POLYGON((10 17, 12 13, 7 15, 10 17))')
),

('obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
),

('obiekt5', ST_Collect(ARRAY[
				ST_GeomFromText('POINT(30 30 59)'),
				ST_GeomFromText('POINT(38 32 234)')]
				)
),
('obiekt6', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(1 1, 3 2)'),
				ST_GeomFromText('POINT(4 2)')]
				)
);



-- zadanie 2 
SELECT ST_Area(ST_Buffer(ST_ShortestLine(x.geometry,y.geometry),5))
FROM obiekty as x
CROSS JOIN obiekty as y 
WHERE x.name = 'obiekt3' AND y.name = 'obiekt4';

-- zadanie 3 
/*
POLIGON - w miernictwie: obszar ograniczony liniami prostymi (PWN)

Nasz obszar nie jest ograniczony/zamknięty --> aby spełnić warunek 
należy go domknąć 
*/

UPDATE obiekty 
SET geometry = ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)')
WHERE name = 'obiekt4';

UPDATE obiekty 
SET geometry = ST_MakePolygon(geometry)
WHERE name = 'obiekt4';

-- zadanie 4 
INSERT INTO obiekty(name, geometry)
SELECT 'obiekt7', ST_Collect(x.geometry, y.geometry)
FROM obiekty as x
INNER JOIN obiekty as y ON  x.name = 'obiekt3' AND y.name = 'obiekt4'

-- zadanie 5 
SELECT name, ST_Area(ST_Buffer(geometry,5)) 
FROM obiekty 
WHERE ST_HasArc(geometry)