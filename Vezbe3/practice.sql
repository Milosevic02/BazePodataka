--Koriscenje dve iste tabele
SELECT r.mbr,r.ime,r.prz,r.plt 
    FROM radnik r,radnik r1
    WHERE r.plt > r1.plt AND r1.mbr = 40;