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

