--ANY
SELECT mbr,ime,prz,plt
    FROM radnik
    WHERE ime = ANY('Pera','Moma');

--ALL
SELECT mbr,ime,prz,plt
    FROM radnik
    WHERE ime != ALL('Pera','Moma');

--NVL
SELECT mbr,plt + NVL(pre,0)
    FROM radnik;

--COALESCE
SELECT COALESCE(NULL,1)
    FROM dual;

--COUNT
SELECT COUNT(*)
    FROM radnik;

SELECT COUNT(DISTINCT sef) broj_sefova
    FROM radnik;

--MIN and MAX
SELECT MIN(plt) minimalna_plt, MAX(plt) maksimalna_plt
    FROM radnik;

--SUM
SELECT COUNT(mbr) "Broj radnika",SUM(plt) "Ukupna mesecna plata"
    FROM radnik;

--AVG 
SELECT COUNT(*) "Broj radnika",AVG(plt) "Prosecna plata",12*SUM(plt) "Godisnja plata"
    FROM radnik;

--ROUND
SELECT ROUND(AVG(plt*1.41),2)
    FROM radnik;

--SELECT in SELECT + ROWNUM
SELECT mbr,plt,ROWNUM
    FROM(SELECT * FROM radnik ORDER BY plt DESC)
    WHERE ROWNUM <=10;

--GROUP BY
SELECT spr,COUNT(mbr),SUM(brc)
    FROM radproj
    GROUP BY spr;

--HAVING 
SELECT mbr,COUNT(spr)
    FROM radproj
    GROUP BY mbr
    HAVING COUNT(spr) > 2;

--Radnici u rastucem redosledu sa vecom platom od prosecne
SELECT mbr,ime,prz,plt
    FROM radnik
    WHERE plt > (SELECT AVG(plt) FROM radnik)
    ORDER BY plt ASC;

--Radnik na projektu 10 a da nije na projektu 30
SELECT mbr,ime,prz
    FROM radnik 
    WHERE mbr IN
        (SELECT mbr FROM radproj WHERE spr = 10)
    AND mbr NOT IN 
        (SELECT mbr FROM radproj WHERE spr = 30);

--Najmladji radnik
SELECT mbr,ime,prz,god
    FROM radnik
    WHERE god = (SELECT MIN(god) FROM radnik);

--Nazivi projekta na kojima radi radnik koji radi na projektu 60
SELECT p.nap
    FROM projekat p
    WHERE spr in (SELECT spr
                    FROM radproj
                    WHERE mbr IN (SELECT mbr
                                    FROM radproj
                                    WHERE spr = 60));

--Spajanje tabela
 SELECT r.mbr,prz,ime,plt,brc
    FROM radnik r,radproj
    WHERE spr = 10 AND r.mbr = radproj.mbr;

--radnika mbr,prz,ime,uk broj proj,ukupno angaz na projektima
SELECT r.mbr,r.prz,r.ime,COUNT(*),SUM(rp.brc)
    FROM radnik r,radproj rp
    WHERE r.mbr = rp.mbr
    GROUP BY r.mbr,r.prz,r.ime;

--sva imena prezimena radnika osim rukovodioca sa sifrom 10
SELECT r.ime,r.prz
    FROM radnik r,projekat p
    WHERE r.mbr != p.ruk AND p.spr = 10;

--Imena prezimena rukovodioca i broj projekata na kojima rade
SELECT r.ime,r.prz,COUNT(rp.spr) bp
    FROM radnik r,radproj rp
    WHERE r.mbr = rp.mbr AND r.mbr IN (SELECT ruk FROM projekat)
    GROUP BY r.mbr,prz,ime;