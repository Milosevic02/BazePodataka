--WITH -> zad1 -> Prikazati za svakog radnika angažovanog na projektu mbr, prz, ime, spr i broj drugih radnika koji su angažovani na istom projektu.   
WITH projinfo AS (
    SELECT rp.spr,COUNT(rp.mbr) AS rad_broj
    FROM radproj rp GROUP BY rp.spr)
SELECT r.mbr, r.ime , r.prz,rp.spr,pi.rad_broj - 1 ostali
    FROM radnik r,radproj rp, projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

--WITH -> zad2 -> Prikazati za svakog radnika angažovanog na projektu mbr, prz, ime, spr i udeo u ukupnom broju časova rada na tom projektu
WITH projinfo AS (
    SELECT rp.spr,SUM(rp.brc) AS cas_suma
        FROM radproj rp 
        GROUP BY rp.spr)
SELECT r.mbr,r.ime,r.prz,rp.spr,ROUND(rp.brc/pi.cas_suma,2) udeo
    FROM radnik r,radproj rp,projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

--WITH-> zad3 ->Prikazati mbr, ime i prz rukovodilaca projekata kao i ukupan broj radnika kojima rukovode na projektima
WITH rukovodilac AS (
    SELECT mbr,ime,prz,plt,spr
        FROM radnik , projekat 
        WHERE mbr = ruk),
    projinfo AS (
        SELECT spr,COUNT(mbr) ljudi
        FROM radproj
        GROUP BY spr)
SELECT ru.mbr,ru.ime,ru.prz,SUM(pi.ljudi) ljudi
    FROM rukovodilac ru,projinfo pi
    WHERE ru.spr = pi.spr
    GROUP BY ru.mbr,ru.ime,ru.prz;

--WITH -> zad4 -> Prikazati mbr, ime, prz, plt radnika čiji je broj sati angažovanja na nekom projektu veći od prosečnog broja sati angažovanja na tom projektu
WITH br_sati_projekta AS(
    SELECT spr , AVG(brc) prosek
        FROM radproj
        GROUP BY spr)
SELECT DISTINCT  r.mbr,r.ime,r.prz,r.plt,bp.spr
    FROM radnik r,br_sati_projekta bp,radproj rp
    WHERE r.mbr = rp.mbr AND rp.spr = bp.spr
    GROUP BY r.mbr,r.ime,r.prz,r.plt,bp.spr
    HAVING AVG(rp.brc) > (SELECT prosek
                            FROM br_sati_projekta bp2
                            WHERE bp2.spr = bp.spr);