--Koriscenje dve iste tabele
SELECT r.mbr,r.ime,r.prz,r.plt 
    FROM radnik r,radnik r1
    WHERE r.plt > r1.plt AND r1.mbr = 40;

--Imena,Prezimena i plate radnika koji zaradjuju bar 1000 din manje od rukovodioca na tom projektu
SELECT r.ime,r.prz,r.plt,p.nap
    FROM radnik r,radnik r1,projekat p,radproj rp
    WHERE r.mbr = rp.mbr AND rp.spr = p.spr AND p.ruk = r1.mbr AND r.plt + 1000 < r1.plt;

--Radnici ciji broj sati angazovanja na nekom projektu veci od prosecnog broja sati angazovanja an tom projektu
SELECT r.mbr,r.prz,r.plt 
    FROM radnik r,radproj rp
    WHERE r.mbr = rp.mbr AND rp.brc > (SELECT AVG(brc) 
                                            FROM radproj rp1
                                            WHERE rp1.spr = rp.spr);
                                        
--EXISTS AND NOT EXISTS zad1 -> Najstariji radnik
SELECT ime,prz,god
    FROM radnik r
    WHERE NOT EXISTS (SELECT mbr
                        FROM radnik r1
                        WHERE r1.god < r.god);

--EXISTS AND NOT EXISTS zad2 -> Radnik koji ne radi ni na jednom projektu
SELECT ime,prz,god
    FROM radnik r
    WHERE NOT EXISTS (SELECT *
                            FROM radproj rp
                            WHERE r.mbr = rp.mbr);

--EXISTS AND NOT EXISTS zad3 -> Radnik koji ne radi na projektu 10
SELECT mbr,ime,prz 
    FROM radnik r
    WHERE NOT EXISTS (SELECT * 
                        FROM radproj rp
                        WHERE r.mbr =  rp.mbr AND rp.spr = 10);

 --EXISTS AND NOT EXISTS zad4 -> Radnici koji nisu rukovodioci
 SELECT mbr,ime,prz
    FROM radnik r
    WHERE NOT EXISTS (SELECT * 
                        FROM projekat p
                        WHERE r.mbr = p.ruk);                   

 --EXISTS AND NOT EXISTS zad5 -> Najmladji rukovodioc
 SELECT DISTINCT mbr,ime,prz,god
    FROM radnik r,projekat p 
    WHERE r.mbr = p.ruk AND NOT EXISTS (SELECT mbr 
                                            FROM radnik r1,projekat p1
                                            WHERE r1.mbr = p1.ruk AND r.god < r1.god);

--UNION -> Radnici na projektu 20 ili im je plata veca od prosecne
SELECT mbr,ime,prz
    FROM radnik 
    WHERE mbr IN (SELECT mbr FROM radproj WHERE spr = 20)
    UNION
    SELECT mbr,ime,prz
    FROM radnik
    WHERE plt > (SELECT AVG(plt) FROM radnik); 
                                        
--UNION ALL -> Radnici na projektu 20 ili im je plata veca od prosecne
SELECT mbr,ime,prz
    FROM radnik
    WHERE mbr IN (SELECT mbr FROM radproj WHERE spr = 20)
    UNION ALL
    SELECT mbr,ime,prz
    FROM radnik
    WHERE plt > (SELECT AVG(plt) FROM radnik);

--INTERSECT -> vraca presek
SELECT mbr,ime,prz
    FROM radnik
    WHERE prz LIKE 'M%' OR prz LIKE 'R%'
    INTERSECT
    SELECT mbr,ime,prz
    FROM radnik
    WHERE prz LIKE 'M%' OR prz LIKE 'P%';

--MINUS -> unija oba skupa bez preseka
SELECT mbr,ime,prz
    FROM radnik
    WHERE prz LIKE 'M%' OR prz LIKE 'R%'
    MINUS
    SELECT mbr,ime,prz
    FROM radnik
    WHERE prz LIKE 'M%' OR prz LIKE 'P%';

--NATURAL JOIN -> ubaci celu levu tabelu i ubaci celu desnu sem kolona koja se zovu isto kao u levoj
SELECT *
    FROM radnik NATURAL JOIN radproj
    WHERE spr = 30;

--INNER JOIN spaja po koloni koju zadam ali dobijamo sve kolone i iz leve i iz desne tabele
SELECT *
    FROM radnik r INNER JOIN radproj rp ON r.mbr = rp.mbr
    WHERE spr = 30;