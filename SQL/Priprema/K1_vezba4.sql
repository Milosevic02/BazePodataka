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

