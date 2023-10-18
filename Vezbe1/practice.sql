--Kreiranje nove tabele
CREATE TABLE faze_projekta(
    Spr integer not null, --šifra faze projekta,
    Sfp integer not null, --sifra projekta,
    Rukfp integer, --rukovodilac faze projekta,
    Nafp varchar2(20), --naziv faze projekta,
    Datp date, --datum početka faze projekta
    CONSTRAINT faze_projekta_PK PRIMARY KEY (spr,sfp),
    CONSTRAINT faze_projekta_fk1 FOREIGN KEY (spr) REFERENCES projekat (spr),
    CONSTRAINT faze_projekta_fk2 FOREIGN KEY (rukfp) REFERENCES radnik (mbr),
    CONSTRAINT faze_projekta_uk UNIQUE(nafp)
);

--Dodavanje atributa u tabelu
ALTER TABLE faze_projekta
    ADD Datz date --datum zavrsetka
    ADD CONSTRAINT dat_ch CHECK (datp <= datz);

--Brisanje tabele 
DROP TABLE faze_projekta;

--Selektovanje
SELECT ime,prz
    FROM radnik;

--Distinct Select
SELECT DISTINCT ime,prz
    FROM radnik;

--SELECT with where
SELECT mbr,ime,prz 
    FROM radnik
    WHERE plt > 25000