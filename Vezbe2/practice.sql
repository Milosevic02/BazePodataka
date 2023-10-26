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