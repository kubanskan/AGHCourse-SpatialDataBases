-- zadanie 1
CREATE DATABASE firma;

-- zadanie 2 
CREATE SCHEMA ksiegowosc;

-- zadanie 3 

CREATE TABLE ksiegowosc.pracownicy (
    id_pracownika SERIAL PRIMARY KEY,  
    imie VARCHAR(30) NOT NULL,         
    nazwisko VARCHAR(30) NOT NULL,     
    adres VARCHAR(255),                
    telefon VARCHAR(15)
);
COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowująca informacje o pracownikach.';


CREATE TABLE ksiegowosc.godziny (
    id_godziny SERIAL PRIMARY KEY,      
    data DATE NOT NULL,                 
    liczba_godzin NUMERIC(6, 2), 
    id_pracownika INT NOT NULL,         
    FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE
);
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowująca liczbę godzin przepracowanych przez pracowników.';



CREATE TABLE ksiegowosc.pensja (
    id_pensji SERIAL PRIMARY KEY,      
    stanowisko VARCHAR(50),   
    kwota NUMERIC(10, 2)); 
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowująca informacje o stanowiskach i podstawowych wynagrodzeniach.';



CREATE TABLE ksiegowosc.premia (
    id_premii SERIAL PRIMARY KEY,      
    rodzaj VARCHAR(30),       
    kwota NUMERIC(10, 2)
);
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela przechowująca informacje o rodzajach i kwotach premii.';



CREATE TABLE ksiegowosc.wynagrodzenie (
    id_wynagrodzenia SERIAL PRIMARY KEY,  
    data DATE NOT NULL,                   
    id_pracownika INT NOT NULL,           
    id_godziny INT NOT NULL,              
    id_pensji INT NOT NULL,              
    id_premii INT,                        
    FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE,
    FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny) ON DELETE CASCADE,
    FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji) ON DELETE CASCADE,
    FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia(id_premii) ON DELETE SET NULL
);
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowująca informacje o wynagrodzeniach pracowników, łącząc pensje, godziny i premie.';

-- zadanie 4 
SET search_path TO ksiegowosc; 

INSERT INTO pracownicy (imie, nazwisko, adres, telefon)
VALUES 
('Jan', 'Kowalski', 'ul. Wesoła 5, Kraków', '123456789'),
('Anna', 'Nowak', 'ul. Kwiatowa 12, Warszawa', '987654321'),
('Karolina', 'Kos', 'ul. Miła 9, Kraków', '234567899'),
('Monika', 'Dzik', 'ul. Polna 120, Warszawa', '345678999'),
('Marek', 'Nowak', 'ul. Opolska 114, Kraków', '456789999'),
('Anna', 'Krok', 'ul. Wodna 9, Warszawa', '567899999'),
('Michał', 'Mos', 'ul. Różana 11, Kraków', '134567811'),
('Kuba', 'Polak', 'ul. Radosna 276, Warszawa', '567349871'),
('Katarzyna', 'Zum', 'ul. Nowa 2, Kraków', '986437591'),
('Piotr', 'Zieliński', 'ul. Kochana 36, Wrocław', '263910448');

INSERT INTO godziny (data, liczba_godzin, id_pracownika)
VALUES 
('2024-10-01', 168.00, 1), 
('2024-10-01', 64.00, 2), 
('2024-10-01', 200.00, 3), 
('2024-10-01', 160.00, 4), 
('2024-10-01', 160.00, 5), 
('2024-10-01', 164.00, 6), 
('2024-10-01', 126.00, 7), 
('2024-10-01', 86.00, 8), 
('2024-10-01', 160.00, 9), 
('2024-10-01', 200.00, 10); 


INSERT INTO pensja (stanowisko, kwota)
VALUES 
('Programista', 12000.00),
('Analityk', 9000.00),
('Kierownik', 20000.00),
('Administrator', 7000.00),
('Specjalista ds. HR', 6000.00),
('Inżynier', 9500.00),
('Asystent', 4500.00),
('Dyrektor finansowy', 14000.00),
('Specjalista IT', 8200.00),
('Księgowy', 6500.00);


INSERT INTO premia (rodzaj, kwota)
VALUES 
('Świąteczna', 1000.00),
('Uznaniowa', 500.00),
('Za wydajność', 700.00),
('Roczna', 2000.00),
('Za frekwencję', 250.00),
('Projektowa', 800.00),
('Za innowacyjność', 600.00),
('Zespołowa', 450.00),
('Okolicznościowa', 550.00),
('Za długoterminową współpracę', 800.00);

INSERT INTO wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii)
VALUES 
('2024-10-05', 1, 1, 1, 1),  
('2024-10-06', 2, 2, 2, 2),  
('2024-10-06', 3, 3, 3, 3), 
('2024-10-07', 4, 4, 4, 4),  
('2024-10-07', 5, 5, 5, 5),  
('2024-10-08', 6, 6, 6, 6), 
('2024-10-08', 7, 7, 7, 7),  
('2024-10-09', 8, 8, 8, 8),  
('2024-10-09', 9, 9, 9, 9),  
('2024-10-10', 10, 10, 10, NULL); 

-- zadanie 5 
-- a)
SELECT imie, nazwisko
FROM pracownicy;

--b) 
SELECT id_pracownika
FROM wynagrodzenie as x
INNER JOIN  pensja as y ON x.id_pensji = y.id_pensji
LEFT JOIN   premia as z ON x.id_premii = z.id_premii
WHERE y.kwota + z.kwota > 1000;

--c)  
SELECT id_pracownika
FROM wynagrodzenie as x
INNER JOIN  pensja as y ON x.id_pensji = y.id_pensji
LEFT JOIN   premia as z ON x.id_premii = z.id_premii
WHERE  z.kwota IS NULL AND y.kwota > 2000;

--d) 
SELECT * 
FROM pracownicy 
WHERE imie LIKE 'J%';

-- e)
SELECT * 
FROM pracownicy 
WHERE imie LIKE '%a'AND LOWER(nazwisko) LIKE '%n%';

-- f)
SELECT y.imie, y.nazwisko, 
	CASE WHEN z.liczba_godzin <= 160 THEN 0 
		 ELSE z.liczba_godzin - 160
	END AS nadgodziny 
FROM wynagrodzenie as x
INNER JOIN  pracownicy as y ON x.id_pracownika = y.id_pracownika
INNER JOIN  godziny    as z ON x.id_godziny = z.id_godziny;

-- g)
SELECT y.imie, y.nazwisko
FROM wynagrodzenie as x 
INNER JOIN  pracownicy as y ON x.id_pracownika = y.id_pracownika
INNER JOIN  pensja as z ON x.id_pensji = z.id_pensji
WHERE kwota BETWEEN 1500 AND 3000;

-- h)
SELECT y.imie, y.nazwisko
FROM wynagrodzenie as x
INNER JOIN  pracownicy as y ON x.id_pracownika = y.id_pracownika
INNER JOIN  godziny    as z ON x.id_godziny = z.id_godziny
WHERE z.liczba_godzin > 160 AND x.id_premii IS NULL;

-- i)
SELECT y.imie, y.nazwisko, z.kwota
FROM wynagrodzenie as x 
INNER JOIN  pracownicy as y ON x.id_pracownika = y.id_pracownika
INNER JOIN  pensja as z ON x.id_pensji = z.id_pensji
ORDER BY  z.kwota;

-- j)
SELECT y.imie, y.nazwisko, z.kwota, w.kwota
FROM wynagrodzenie as x 
INNER JOIN  pracownicy as y ON x.id_pracownika = y.id_pracownika
INNER JOIN  pensja as z ON x.id_pensji = z.id_pensji
LEFT JOIN   premia as w ON x.id_premii = w.id_premii
ORDER BY  z.kwota,w.kwota DESC;

-- k)
SELECT y.stanowisko, COUNT(*)
FROM wynagrodzenie as x 
INNER JOIN pensja as y ON x.id_pensji = y.id_pensji
GROUP BY y.stanowisko;

-- l)
SELECT y.stanowisko, MIN(y.kwota), MAX(y.kwota), AVG(ky.wota)
FROM wynagrodzenie as x 
INNER JOIN pensja as y ON x.id_pensji = y.id_pensji
WHERE y.stanowisko = 'Kierownik'
GROUP BY y.stanowisko;

-- m)
SELECT SUM(y.kwota)
FROM wynagrodzenie as x 
INNER JOIN pensja as y ON x.id_pensji = y.id_pensji;

-- f)
SELECT y.stanowisko, SUM(y.kwota)
FROM wynagrodzenie as x 
INNER JOIN pensja as y ON x.id_pensji = y.id_pensji
GROUP BY y.stanowisko;

-- g)
SELECT y.stanowisko, COUNT(x.id_premii)
FROM wynagrodzenie as x 
INNER JOIN pensja as y ON x.id_pensji = y.id_pensji
GROUP BY y.stanowisko;

-- h)
DELETE FROM pracownicy
WHERE id_pracownika IN (
    SELECT x.id_pracownika
    FROM ksiegowosc.wynagrodzenie x
    JOIN ksiegowosc.pensja y ON x.id_pensji = y.id_pensji
    WHERE y.kwota < 1200
);
