--1. Prikazati imena i prezimena svih radnika sortirano u opadajucem redosledu na osnovu imena
SELECT ime,prz
    FROM radnik 
    ORDER BY ime DESC;

--2. Povecati plate za 30% svim radnicima ciji je maticni broj 70 i manji
UPDATE radnik
    SET plt = plt*1.30
    WHERE mbr <= 70;

--3. Ispisati maticni broj, ime i prezime radnika cije prezime pocinje na slovo M dok ime ne pocinje slovom M.
SELECT mbr,ime,prz
    FROM radnik
    WHERE prz LIKE 'M%' and ime NOT LIKE 'M%';

--4. Prikazati broj radnika, prosecnu mesecnu platu zaokruzenu na dve decimale i ukupnu godisnju platu svih radnika
SELECT COUNT(mbr) radnika,ROUND(AVG(plt),2) mesecna, SUM(plt*12)
    FROM radnik

--5. Izlistati u opadajucem redosledu plate, mbr, ime, prz i plt radnika koji imaju platu manju od prosecne
SELECT mbr,ime,prz,plt 
    FROM radnik 
    WHERE plt < (SELECT AVG(plt) FROM radnik)
    ORDER BY plt DESC,ime DESC,prz DESC;

--6. Izlistati nazive i sifre projekata na kojima je prosecno angazovanje vece od prosecnog angazovanja na svim projektima
SELECT p.nap,p.spr 
    FROM projekat p,radproj rp
    WHERE rp.spr = p.spr 
    GROUP BY p.spr,p.nap
    HAVING AVG(rp.brc) > (SELECT AVG(rp2.brc) FROM radproj rp2);

--7. Prikazati za svakog radnika angazovanog na projektu mbr, prz, ime, spr i udeo u ukupnom broju casova rada na tom projektu (zaokruzeno na dve decimale)
WITH projinfo AS(
    SELECT rp.spr,SUM(rp.brc) AS cas_suma
    FROM radproj rp
    GROUP BY rp.spr)
SELECT r.mbr, r.ime, r.prz, rp.spr, ROUND(rp.brc/pi.cas_suma, 2) Udeo
    FROM radnik r,radproj rp,projinfo pi
    WHERE r.mbr = rp.mbr and pi.spr = rp.spr;

--8. Svim radnicima promeniti prezime tako da poslednje slovo bude uvecano. Primer AnA -> AnA, Markovic -> MarkoviC
UPDATE radnik
    SET prz = SUBSTR(prz, 1, LENGTH(prz) - 1) || UPPER(SUBSTR(prz,LENGTH(prz), 1));

--9. Napraviti pogled koji ce za sve radnike prikazati Mbr i ukupan broj sati angazovanja radnika na projektima na kojima radi
CREATE OR REPLACE VIEW radinfo AS
    SELECT r.mbr,NVL(SUM(brc),0) br_casova
        FROM radnik r,radproj rp
        WHERE r.mbr = rp.mbr
        GROUP BY r.mbr;

--10. Za svakog radnika prikazati maticni broj, ime, prezime, kao i broj projekata kojima rukovodi, pri cemu je potrebno prikazati
--iskljucivo one radnike koji su rukovodioci na vecem broju projekata od prosecnog broja projekata na kojima rade radnici cije se prezime zavrsava na "ic"
SELECT mbr, ime, COUNT(spr) br_pr_rukovodi
    FROM radnik r LEFT OUTER JOIN  projekat p on r.mbr=p.ruk
    GROUP BY mbr, ime
    HAVING COUNT(spr) > (SELECT AVG(COUNT(spr))
                            FROM radproj rp, radnik r
                            WHERE rp.mbr = r.mbr and prz LIKE '%ic'
                            GROUP BY r.mbr);