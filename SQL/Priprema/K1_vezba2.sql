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