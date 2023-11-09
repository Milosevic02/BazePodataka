--WITH -> zad1 -> Prikazati za svakog radnika angažovanog na projektu mbr, prz, ime, spr i broj drugih radnika koji su angažovani na istom projektu.   
WITH projinfo AS (
    SELECT rp.spr,COUNT(rp.mbr) AS rad_broj
    FROM radproj rp GROUP BY rp.spr)
SELECT r.mbr, r.ime , r.prz,rp.spr,pi.rad_broj - 1 ostali
    FROM radnik r,radproj rp, projinfo pi
    WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;
