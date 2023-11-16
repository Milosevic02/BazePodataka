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

--7. Prikazati sve korisnike (KORIMEK, IMEK, PRZK) čije ocene filmova obuhvataju najviše dva različita žanra. 
--Rezultat treba da uključi i korisnike koji nisu ocenili ni jedan film.
SELECT korimek,imek,przk 
    FROM korisnik k LEFT OUTER JOIN ocena o ON korimeo = korimek
        LEFT OUTER JOIN film f ON idf = filmo
    GROUP BY korimek,imek,przk
    HAVING COUNT(DISTINCT zanrf) < 3;
    
--8. Svim filmovima izmeniti nazive tako da početno slovo svake reči bude veliko. Sva ostala slova treba da budu mala.
SELECT nazivf 
    FROM film
    WHERE nazivf = initcap(nazivf);

--9. Kreirati pogled Prosecne_Ocene_Po_Zanru koji će za svaki žanr (IDZ, NAZIVZ) prikazati prosečnu ocenu filmova toga žanra. Prosečnu ocenu
--zaokružiti na dve decimale. Za žanrove za koje ne postoji ocenjeni filmovi, prikazati ocenu 0.
CREATE OR REPLACE VIEW Prosecne_Ocene_Po_Zanru AS
        SELECT idz, nazivz,ROUND(NVL(AVG(ocenao),0),2) prosek
            FROM film f 
                RIGHT OUTER JOIN zanr z ON idz = zanrf
                LEFT OUTER JOIN ocena o ON filmo = idf
            GROUP BY idz,nazivz;

--10. Za svaki žanr (IDZ, NAZIVZ) prikazati ukupan broj filmova, broj filmova koji traju duže od 100 minuta
--i broj filmova čije trajanje je manje ili jednako 100 minuta. Prikazati i žanrove za koje ne postoje uneseni filmovi.
WITH filmovi_vise AS(
    SELECT idz,idf
        FROM zanr LEFT OUTER JOIN film ON idz = zanrf
        WHERE trajanjef > 100 OR trajanjef IS NULL
      ),
filmovi_manje AS(
    SELECT idz,idf 
        FROM zanr LEFT OUTER JOIN film ON idz = zanrf
        WHERE trajanjef <= 100 OR trajanjef IS NULL)
SELECT z.idz,z.nazivz,COUNT(DISTINCT f.idf) as ukupno_filmova,COUNT(DISTINCT fv.idf) as duzih,COUNT(DISTINCT fm.idf) as kracih
    FROM zanr z 
            LEFT OUTER JOIN film f ON z.idz = zanrf
            LEFT OUTER JOIN filmovi_vise fv ON fv.idz = z.idz
            LEFT OUTER JOIN filmovi_manje fm ON fm.idz = z.idz
    GROUP BY z.idz,nazivz;