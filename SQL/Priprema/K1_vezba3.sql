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

--5. Za svakog korisnika (KORIMEK, IMEK, PRZK) izlistati nazive svih filmova žanra Romantični koje je ocenio. Prikazati i ocene koje je korisnik
--dodelio ovim filmovima. Rezultate sortirati u opadajućem redosledu po korisničkom imenu.
SELECT k.korimek,k.imek,przk ,o.ocenao
    FROM film f 
        INNER JOIN ocena o ON f.idf = o.filmo
        INNER JOIN korisnik k ON o.korimeo = k.korimek 
    WHERE f.zanrf = 20;

--6. Prikazati sve korisnike (KORIMEK, IMEK, PRZK) koji su ocenili film sa nazivom Pokajanje, ali nisu ocenili film sa nazivom Grdana.
SELECT k.korimek,k.imek,przk
    FROM korisnik k INNER JOIN ocena o ON korimeo = korimek
        INNER JOIN film f ON idf = filmo
    WHERE nazivf = 'Pokajanje' AND korimeo NOT IN (SELECT o2.korimeo FROM ocena o2 WHERE filmo = 5)
    