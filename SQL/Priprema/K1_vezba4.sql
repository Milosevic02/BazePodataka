--1. Prikazati države (IDD, NAZIVD), sortirane u rastućem redosledu naziva države
SELECT idd,nazivd 
    FROM drzava
    ORDER BY nazivd;

--2. Prikazati sve vozače (IDV, IMEV, PREZV) koji u imenu malo slovo ‘n’ ili veliko slovo ‘L’
SELECT idv,imev,prezv
    FROM vozac
    WHERE imev LIKE '%n%' OR imev LIKE '%L%';

--3. U tabelu Staza, dodati kolone GEO_SIRINA i GEO_DUZINA koje predstavljaju decimalnu predstavu geografke širine i dužine na kojima se staza
-- nalazi. Kao podrazumevanu vrednost kolona postaviti nedostajuću vrednost NULL.
ALTER TABLE staza
ADD(geo_sirina DECIMAL(10,8) DEFAULT NULL);

ALTER TABLE staza
ADD(geo_duzina DECIMAL(11,8) DEFAULT NULL);

--4.Prikazati staze (idenfikacionu oznaku staze, naziv staze i naziv države u kojoj se staza nalazi) na kojima je barem jedan vozač 2019. godine ostvario
-- broj poena manji od prosečnog broja poena za sve vožnje iz 2019. godine. Ukoliko su na nekoj stazi dva ili više vozača ostvarila takav broj bodova, stazu prikazati samo jednom.
SELECT DISTINCT ids,nazivs,drzs
    FROM staza INNER JOIN rezultat ON ids = stazar
        INNER JOIN vozac ON idv = vozacr
    WHERE sezona = 2019 AND bodovi < (SELECT AVG(bodovi) FROM rezultat WHERE sezona = 2019);

--5. Prikazati sve staze (idenfikaciona oznaka staze, naziv staze i naziv države u kojoj se staza nalazi) na kojim je barem jednom pobedio domaći
--vozač (vozač koji nastupa za istu državu u kojoj se staza nalazi). Ukoliko je na nekoj stazi više sezona pobedio domaći vozač, stazu prikazati samo jednom.
SELECT DISTINCT ids,nazivs,drzs
    FROM staza INNER JOIN rezultat ON ids = stazar
        INNER JOIN vozac ON idv = vozacr
    WHERE drzv = drzs AND plasman = 1;

--6. Prikazati sve staze na kojima je nastupao barem jedan vozač koji nastupa za državu sa nazivom Germany, a nije nastupao ni jedan vozač koji nastupa za državu sa nazivom Finland. 
SELECT DISTINCT s.* 
    FROM staza s
        INNER JOIN vozac ON drzs = drzv
        INNER JOIN drzava d1 ON drzv = d1.idd
        WHERE d1.nazivd = 'Germany' AND ids NOT IN (SELECT s1.ids
                                                        FROM staza s1
                                                                JOIN Vozac V1 ON S1.DRZS = V1.DRZV
                                                                JOIN Drzava D2 ON V1.DRZV = D2.IDD
                                                                WHERE D2.NAZIVD = 'Finland');

--7. Za svaku stazu (IDS, NAZIVS) prikazati broj različitih pobednika. Prikazati samo one staze na kojima su pobeđivala najviše dva različita
--vozača. Za staze za koje nisu uneseni rezultati prikazati 0.                                                           
SELECT ids,nazivs,COUNT(DISTINCT vozacr)
    FROM staza LEFT OUTER JOIN rezultat ON ids = stazar
    WHERE plasman = 1
    GROUP BY ids,nazivs
    HAVING COUNT(DISTINCT vozacr) < 2;