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

--4. Prikazati korisnike (KORIMEK, IMEK, PRZK) koji su ocenili barem jedan od filmova koji su snimljeni nakon prosečne godine snimanja svih
--filmova. Ukoliko je jedan korisnik ocenio više ovakvih filmova, prikazati ga samo jednom.
SELECT DISTINCT korimek,imek,przk 
    FROM film f INNER JOIN ocena o ON idf = filmo
            INNER JOIN korisnik k ON korimeo = korimek
    WHERE f.godf > (SELECT AVG(f2.godf) FROM film f2)