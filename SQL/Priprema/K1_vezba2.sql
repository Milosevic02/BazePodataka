--1.Prikazati imena i prezimena svih radnika sortirano u opadajucem redosledu na osnovu imena
SELECT ime,prz
    FROM radnik 
    ORDER BY ime DESC;

--Povecati plate za 30% svim radnicima ciji je maticni broj 70 i manji
UPDATE radnik
    SET plt = plt*1.30
    WHERE mbr <= 70;