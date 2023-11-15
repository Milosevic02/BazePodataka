/*
    ***Rad sa tabelama***

    -> CREATE TABLE
    -> ALTER TABLE -> izmena tabele:
        - ADD -> dodavanje u tabelu
        - MODIFY -> Izmena kolone
        - DROP COLUMN -> Brisanje kolone
        - ADD CONSTRAINT -> Uslov 
        *Primer:*/  ADD(datz date, CONSTRAINT dat_ch CHECK (datp<=datz));

/*
    ***Azuriranje Podataka***

    -> INSERT -> INSERT INTO projekat (spr, nap, ruk) VALUES (90, 'P1', 201);
    -> DELETE ->DELETE FROM radnik WHERE mbr = 701;
    -> UPDATE -> UPDATE radnik SET plt = plt*1.2;


    ***Ugradjene Funkcije***
    -> NULL and NOT NULL
    -> BETWEEN and NOT BETWEEN -> [pocetna,krajnja] 
    -> LIKE and NOT LIKE :
          _ ->  Zamenjuje tacno jedan karakter -> Ma_ko
          % -> niz od nula ili vise prozivoljnih karaktera -> M% 
    -> IN and NOT IN -> SELECT DISTINCT mbr FROM radproj WHERE spr IN (10, 20, 30);
    -> ORDER BY :
        - ASC -> rastuci
        - DESC -> opadajuci
    -> ANY -> SELECT mbr,ime,prz,plt FROM radnik WHERE ime = ANY('Pera','Moma');
    -> ALL -> SELECT mbr,ime,prz,plt FROM radnik WHERE ime != ALL('Pera','Moma');
    -> NVL => Ako je nesto NULL menja time. Moraju biti istog tipa oba parametra
        - SELECT mbr,plt + NVL(pre,0) FROM radnik;
    -> COUNT 
    -> MIN and MAX
    -> SUM
    -> AVG
    -> ROUND -> Zaokruzuje broj na odredjen broj decimala -> SELECT ROUND(AVG(plt*1.41),2) FROM radnik;
    -> ROWNUM -> broj reda u tabeli
    -> GROUP BY + HAVING -> U GROUP BY uvek moraju biti sva polja iz select sem funkcija(SUM,AVG...)
        SELECT mbr,COUNT(spr) FROM radproj GROUP BY mbr HAVING COUNT(spr) > 2;
    -> EXISTS AND NOT EXISTS -> Cesto se koristi sa ugnjezdenim selectom
    -> UNION -> Spaja dva select upita(sluzi kao ili) i brise duplikate
    -> UNION ALL -> Isto kao UNION samo ne brise duplikate
    -> INERSECT -> Presek Dve SELECT naredbe
    -> MINUS -> Unija oba skupa bez preseka
    

    ***Spajanje tabela***

    -> NATURAL JOIN -> Spaja po kolonama sa istim nazivom
    -> INNER JOIN -> Unutrasnje spajanje sa ON biramo po cemu
    -> LEFT and RIGHT OUTER JOIN -> zadrzava jednu tabelu celu i spaja drugu sa njom ako nema vrednosti u drugoj tabeli pise NULL
    -> FULL OUTER JOIN -> Ostavlja sve i iz leve i iz desne tabele i dodeljuje null za vrednosti koje fale
    -> CROSS JOIN -> Dekartov proizvod


    ***CASE***
        SELECT mbr,ime,plt,
        CASE
            WHEN plt < 10000 THEN 'mala primanja'
            WHEN plt >= 10000 AND plt < 20000 THEN 'srednja primanja'
            WHEN plt >= 20000 AND plt <40000 THEN 'visoka primanja'
            ELSE 'izuzetno visoka primanja'
        END AS visina_primanja
        FROM radnik
        ORDER BY
            CASE visina_primanja
                WHEN 'izuzetno visoka primanja' THEN 1
                WHEN 'visoka primanja' THEN 2
                WHEN 'srednja primanja' THEN 3
                ELSE 4
            END DESC,plt ASC; 

    ***

    ***WITH***
        -> Deljenje zadatka u manje zadatke

        Prikazati mbr, ime, prz, plt radnika čiji je broj sati angažovanja na nekom projektu veći od prosečnog broja sati angažovanja na tom projektu
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

     ***VIEW*** 

        CREATE OR REPLACE VIEW angaz_po_radnicima (MBR,SBrc) AS
            SELECT r.mbr,NVL(SUM(rp.Brc),0)
            FROM radnik r LEFT OUTER JOIN radproj rp ON r.mbr = rp.mbr GROUP BY r.mbr;

        DROP VIEW pogled;

    ***CHARACTER FUNCTION***

        -> LOWER('Sva mala slova') → 'sva mala slova'
        -> UPPER('Sva velika slova') → 'SVA VELIKA SLOVA'
        -> INITCAP('Velika početna slova') → ' Velika Početna Slova'
        -> SUBSTR('DobroJutro', 1, 5) → 'Dobro'
        -> TRIM('D' FROM 'DobroJutro') → 'obroJutro' || TRIM(TRAILING 'a' FROM Pera) -> Per
        -> LENGTH('DobroJutro') → 10      

    ***CONVERSION FUNCTION***

        TO_CHAR(d [, fmt]) – transformiše vrednosti tipa DATE u VARCHAR2, po izboru uz navedeni format datuma
        TO_CHAR(n [, fmt]) – transformiše vrednost brojčanog tipa u VARCHAR2, po izboru uz navedeni format broja
        TO_DATE(char [, fmt]) – za konvertovanje niza znakova u ekvivalentni datum
        TO_NUMBER(char [,fmt]) – za konvertovanje znakovnih vrednosti u numeričke

    