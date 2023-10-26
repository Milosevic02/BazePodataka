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