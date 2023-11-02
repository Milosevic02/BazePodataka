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
                    
                                  