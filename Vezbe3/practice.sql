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

--LEFT OUTER JOIN -> Zadrzava levu tabelu i prikazuje null u desnoj tabeli
SELECT *
    FROM radnik r LEFT OUTER JOIN radproj rp ON r.mbr = rp.mbr;

--LEFT OUTER JOIN zad1 -> Ispisati ime prz mbr i naziv projekta kojim rukovodi ako ne rukovodi ni jednim ispisati ne rukovodi
SELECT r.mbr,r.ime,r.prz,NVL(nap,'Ne rukovodi projektom') Projekat
    FROM radnik r LEFT OUTER JOIN projekat p ON r.mbr = p.ruk;

--RIGHT OUTER JOIN -> Zadrzava desnu tabelu i prikazuje null u levoj tabeli
SELECT *
    FROM radproj rp RIGHT OUTER JOIN projekat p ON rp.spr = p.spr;

--FULL OUTER JOIN ->
SELECT *
    FROM radproj rp FULL OUTER JOIN projekat p ON rp.spr = p.spr;

--CROSS JOIN -> dekartov proizvod
SELECT *
    FROM radnik CROSS JOIN projekat;

--JOIN zad1 -> radnici i projekti na kojima rade
SELECT r.mbr,r.prz,r.ime,NVL(p.spr,0) spr ,NVL(p.nap,'Ne postoji') naziv
    FROM radnik r LEFT OUTER JOIN radproj rp ON r.mbr = rp.mbr LEFT OUTER JOIN projekat p ON rp.spr = p.spr
    ORDER BY mbr;

--JOIN zad2 -> radnici koji rade na projektu
SELECT r.mbr,ime,prz,NVL(rp.spr,0)
    FROM radnik r LEFT OUTER JOIN radproj rp ON r.mbr = rp.mbr;

--JOIN zad3 -> radnici i njihovi sefovi
SELECT r.ime,r.prz "Radnik",NVL(r1.prz,'Nema sefa') Sef
    FROM radnik r LEFT OUTER JOIN radnik r1 ON r.sef = r1.mbr
    ORDER BY r.prz;
    
--JOIN zad4 -> Za satnicu prikazati koliko radnika radi na tom projektu sa tom satnicom
SELECT brc,COUNT(mbr)
FROM radproj GROUP BY brc
ORDER BY brc DESC;

--JOIN zad5 -> radnici koji rade na manje projekata od prosecnog broja projekata na kojima rade radnici cije se prezime zavrsava na ic
SELECT mbr,ime,COUNT(spr) broj_pr_rukovodi
    FROM radnik r LEFT OUTER JOIN projekat p ON r.mbr = p.ruk
    GROUP BY mbr,ime HAVING COUNT(spr) < (SELECT AVG(COUNT(spr))
                                            FROM radproj rp,radnik r
                                            WHERE rp.mbr = r.mbr
                                            AND prz NOT LIKE '%ic'
                                            GROUP BY r.mbr);