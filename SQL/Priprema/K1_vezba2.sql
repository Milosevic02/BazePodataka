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