--1. Prikazati filmove (IDF, NAZIVF), sortirane u rastućem redosledu naziva filma
SELECT idf,nazivf 
    FROM film 
    ORDER BY nazivf;

--2. Prikazati sve filmove (IDF, NAZIVF, TRAJANJEF) čije trajanje je u
-- opsegu [100, 150] minuta
SELECT idf,nazivf,trajanjef
    FROM film
    WHERE trajanjef BETWEEN 100 and 150;

--3. U tabelu Ocena dodati ograničenje tako da dodeljena ocena (OCENAO)
-- mora biti u opsegu [1, 10].
ALTER TABLE Ocena
    ADD CONSTRAINT check_ocena_range CHECK (OCENAO >= 1 AND OCENAO <= 10);
    