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