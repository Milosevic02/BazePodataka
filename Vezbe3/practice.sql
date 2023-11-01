--Koriscenje dve iste tabele
SELECT r.mbr,r.ime,r.prz,r.plt 
    FROM radnik r,radnik r1
    WHERE r.plt > r1.plt AND r1.mbr = 40;

--Imena,Prezimena i plate radnika koji zaradjuju bar 1000 din manje od rukovodioca na tom projektu
SELECT r.ime,r.prz,r.plt,p.nap
    FROM radnik r,radnik r1,projekat p,radproj rp
    WHERE r.mbr = rp.mbr AND rp.spr = p.spr AND p.ruk = r1.mbr AND r.plt + 1000 < r1.plt;

