--WITH -> zad1 -> Prikazati za svakog radnika angažovanog na projektu mbr, prz, ime, spr i broj drugih radnika koji su angažovani na istom projektu.   
WITH projinfo AS (
    SELECT rp.spr,COUNT(rp.mbr) AS rad_broj
    FROM radproj rp GROUP BY rp.spr)
SELECT r.mbr, r.ime , r.prz,rp.spr,pi.rad_broj - 1 ostali
    FROM radnik r,radproj rp, projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

--WITH -> zad2 -> Prikazati za svakog radnika angažovanog na projektu mbr, prz, ime, spr i udeo u ukupnom broju časova rada na tom projektu
WITH projinfo AS (
    SELECT rp.spr,SUM(rp.brc) AS cas_suma
        FROM radproj rp 
        GROUP BY rp.spr)
SELECT r.mbr,r.ime,r.prz,rp.spr,ROUND(rp.brc/pi.cas_suma,2) udeo
    FROM radnik r,radproj rp,projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

--WITH-> zad3 ->Prikazati mbr, ime i prz rukovodilaca projekata kao i ukupan broj radnika kojima rukovode na projektima
WITH rukovodilac AS (
    SELECT mbr,ime,prz,plt,spr
        FROM radnik , projekat 
        WHERE mbr = ruk),
    projinfo AS (
        SELECT spr,COUNT(mbr) ljudi
        FROM radproj
        GROUP BY spr)
SELECT ru.mbr,ru.ime,ru.prz,SUM(pi.ljudi) ljudi
    FROM rukovodilac ru,projinfo pi
    WHERE ru.spr = pi.spr
    GROUP BY ru.mbr,ru.ime,ru.prz;

--WITH -> zad4 -> Prikazati mbr, ime, prz, plt radnika čiji je broj sati angažovanja na nekom projektu veći od prosečnog broja sati angažovanja na tom projektu
WITH br_sati_projekta AS(
    SELECT spr , AVG(brc) prosek
        FROM radproj
        GROUP BY spr)
SELECT DISTINCT  r.mbr,r.ime,r.prz,r.plt,bp.spr
    FROM radnik r,br_sati_projekta bp,radproj rp
    WHERE r.mbr = rp.mbr AND rp.spr = bp.spr
    GROUP BY r.mbr,r.ime,r.prz,r.plt,bp.spr
    HAVING AVG(rp.brc) > (SELECT prosek
                            FROM br_sati_projekta bp2
                            WHERE bp2.spr = bp.spr);

--WITH -> zad5 -> Prikazati mbr, ime, prz, plt radnika čiji je broj sati angažovanja na nekom projektu veći od prosečnog angažovanja na svim projektima.
WITH projinfo AS(
    SELECT spr, AVG(brc) pros
        FROM radproj GROUP BY spr)
SELECT r.mbr,r.ime,r.prz,r.plt , AVG(rp.brc)
    FROM radnik r,radproj rp,projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr
    GROUP BY r.mbr,r.ime,r.prz,r.plt ,pi.spr
    HAVING AVG(rp.brc) > (SELECT AVG(pros) from projinfo);

--WITH -> zad6 -> Koliko je ukupno angažovanje svih šefova na projektima?
WITH angaz_po_radnicima (mbr, sbrc) AS (
    SELECT r.mbr, nvl(SUM(rp.brc), 0)
    FROM radnik r, radproj rp
    WHERE r.mbr = rp.mbr (+)
    GROUP BY r.mbr),
angaz_sefova (mbr, prz, ime, brrad, brsat) AS (
    SELECT distinct r.sef, r1.prz, r1.ime, count(*), a.sbrc
    FROM radnik r, radnik r1, angaz_po_radnicima a
    WHERE r.Sef = r1.Mbr AND r.Sef = a.Mbr
    GROUP BY r.Sef, r1.Prz, r1.Ime, a.SBrc)
SELECT SUM(brsat) AS ukangsef
FROM angaz_sefova; 

--VIEW -> zad1 -> Napraviti pogled koji će za sve radnike prikazati samo njihova imena, prezimena i platu.
CREATE OR REPLACE VIEW plate_radnika (Ime,Prezime,Plata) AS
    SELECT Ime,Prz,Plt
    FROM radnik;

--VIEW -> zad2 -> Napraviti pogled koji će za sve radnike prikazati Mbr i ukupan broj sati angažovanja radnika na projektima na kojima radi.
CREATE OR REPLACE VIEW angaz_po_radnicima (MBR,SBrc) AS
    SELECT r.mbr,NVL(SUM(rp.Brc),0)
    FROM radnik r LEFT OUTER JOIN radproj rp ON r.mbr = rp.mbr GROUP BY r.mbr;

--VIEW -> zad3 -> Napraviti pogled koji će za svakog šefa (rukovodioca radnika) prikazati njegov matični broj, prezime, ime, ukupan broj radnika
--kojima šefuje i njegovo ukupno angažovanje na svim projektima, na kojima radi. Koristiti prethodno definisani pogled.
CREATE OR REPLACE VIEW angaz_sefova(Mbr,Prz,Ime,BrRad,BrSat) AS
    SELECT r.Sef,r1.prz,r1.ime,COUNT(*),a.SBrc
        FROM radnik r, radnik r1,angaz_po_radnicima a
        WHERE r.Sef = r1.mbr AND r.sef = a.mbr
        GROUP BY r.Sef, r1.Prz, r1.Ime, a.SBrc;

--VIEW -> zad4 -> Koliko je ukupno angažovanje svih šefova na projektima?
SELECT SUM(BrSat) AS Ukupno FROM angaz_sefova;

--SEQUENCE 
CREATE SEQUENCE SEQ_Mbr
    INCREMENT BY 10
    START WITH 240
    NOCYCLE
    CACHE 10;
    
INSERT INTO radnik (mbr,prz,ime,god)
VALUES (SEQ_Mbr.NEXTVAL,'Napier','Sabaz',SYSDATE);

SELECT SEQ_Mbr.CURRVAL FROM SYS.DUAL;

--Rad sa tabelama
SELECT table_name FROM user_tables;

SELECT DISTINCT object_type FROM user_objects;

SELECT * FROM user_catalog;

/* 
CHARACTER FUNCTION:

    LOWER('Sva mala slova') → 'sva mala slova'
    UPPER('Sva velika slova') → 'SVA VELIKA SLOVA'
    INITCAP('Velika početna slova') → ' Velika Početna Slova'
    SUBSTR('DobroJutro', 1, 5) → 'Dobro'
    TRIM('D' FROM 'DobroJutro') → 'obroJutro' || TRIM(TRAILING 'a' FROM Pera) -> Per
    LENGTH('DobroJutro') → 10
*/

--CHARACTER FUNCTION -> zad1 
SELECT Mbr,Ime,Prz
    FROM radnik
    WHERE UPPER(prz) = 'PETRIC'; 

--CHARACTER FUNCTION -> zad2 -> Prikazati radnike čije prezime na početku sadrži prva 3 slova imena, na primer: Petar Petric
SELECT *
    FROM radnik 
    WHERE prz LIKE
    SUBSTR(IME,0,3) || '%';

--CHARACTER FUNCTION -> zad3 ->  Prikazati imena i prezimena radnika tako da se sva imena koja imaju poslednje slovo 'a', prikazuju bez poslednjeg slova.
SELECT TRIM(TRAILING 'a' FROM ime)
    FROM radnik;

--CHARACTER FUNCTION -> zad4 -> Prikazati matične brojeve, spojena (konkatenirana) imena i prezimena radnika, kao i plate, uvećane za 17%.
SELECT mbr,ime || ' ' || prz "Ime i Prezime",plt*1.17 Plata
    FROM radnik;

--CHARACTER FUNCTION -> zad5 -> Prikazati radnike čije prezime sadrži ime. Na primer Marko Marković, ili Djordje Karadjordjevic
SELECT * 
    FROM radnik 
    WHERE LOWER(prz) LIKE '%' || LOWER(ime) || '%';

/*
CONVERSION FUNCTION

    TO_CHAR(d [, fmt]) – transformiše vrednosti tipa DATE u VARCHAR2, po izboru uz navedeni format datuma
    TO_CHAR(n [, fmt]) – transformiše vrednost brojčanog tipa u VARCHAR2, po izboru uz navedeni format broja
    TO_DATE(char [, fmt]) – za konvertovanje niza znakova u ekvivalentni datum
    TO_NUMBER(char [,fmt]) – za konvertovanje znakovnih vrednosti u numeričke
*/

-- CONVERSION FUNCTION -> zad1 -> Za svakog radnika prikazati ime, prz, i projekte na kojima radi. Ako ne radi ni na jednom projektu, napisati ‘Ne radi na
--projektu’. Imena radnika prikazati velikim slovima, a prezimena malim.
SELECT UPPER(ime),LOWER(prz),NVL(TO_CHAR(spr),'Ne radi na projektu') broj_proj
    FROM radnik LEFT OUTER JOIN radproj ON radnik.mbr = radproj.mbr;

--CONVERSION FUNCTION -> zad2 ->  Za svakog radnika prikazati datum rođenja u formatu yyyy/mm/dd.
SELECT TO_CHAR(god,'yyyy/mm/dd') FROM radnik;

-- ***ANALITIC FUNCTION***

-- OVER() -> zad1 -> Svaki red ce imati istu vrednost proseka
SELECT r.mbr, r.ime, r.prz, rp.spr, rp.brc, AVG(rp.brc) OVER() AS prosek_brc_ukupni
FROM radnik r INNER JOIN radproj rp ON r.mbr=rp.mbr;

-- OVER() -> zad2 -> Prikazati mbr, ime, prz radnika angažovanih na projektima. Pored toga, prikazati spr i brc projekata na kojima su angažovani,
--kao i prosečno angažovanje na tom projektu
SELECT r.mbr, r.ime, r.prz, rp.spr, rp.brc,
    AVG(rp.brc) OVER (PARTITION BY rp.spr) AS prosek_brc_za_projekat
    FROM radnik r INNER JOIN radproj rp ON r.mbr=rp.mbr;

-- KUMULATIVNI ZBIR -> zad1 -> Prikazati mbr, datum isplate, razlog isplate, isplaćeni iznos, kao i kumulativnu sumu isplaćenog iznosa od početka 2023.
--godine za radnika sa matičnim brojem 70.
SELECT mbr,datum_isplate,razlog_isplate,iznos,
    SUM(iznos) OVER (ORDER BY datum_isplate) AS kumulativni_zbir
    FROM isplate_radnicima
    WHERE mbr = 70 AND godina = 2023
    ORDER BY datum_isplate;

/*
○ uslov_odabira_torki (engl. windowing clause)
○ RANGE BETWEEN početna_tačka AND krajnja_tačka
○ ROWS BETWEEN početna_tačka AND krajnja_tačka
○ Moguće vrednosti za početnu i krajnju tačku:
■ UNBOUNDED PRECEDING (samo početna)
■ UNBOUNDED FOLLOWING (samo krajnja)
■ CURRENT ROW
*/  

--KUMULATIVNI ZBIR -> zad2 ->Prikazati mbr, ime, prz radnika angažovanih na projektima. Pored toga, prikazati spr i brc projekata na kojima su angažovani,
--kao i kumulativnu sumu broja sati rada za radnike uređene od najmlađeg do najstarijeg.
SELECT r.mbr, r.ime, r.prz, rp.spr, rp.brc,
    SUM(rp.brc) OVER(partition by rp.spr ORDER BY god DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS kumlativni_zbir
    FROM radnik r INNER JOIN radproj rp ON r.mbr = rp.mbr;
