--1. Prikazati filmove (IDF, NAZIVF), sortirane u rastućem redosledu naziva filma
SELECT idf,nazivf 
    FROM film 
    ORDER BY nazivf;

--2. Prikazati sve filmove (IDF, NAZIVF, TRAJANJEF) čije trajanje je u
-- opsegu [100, 150] minuta
SELECT idf,nazivf,trajanjef
    FROM film
    WHERE trajanjef BETWEEN 100 and 150;