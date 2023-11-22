# Biblioteka

Nacrtati ER konceptualnu šemu baze podataka BIBLIOTEKA, na osnovu tekstualnog opisa realnih entiteta i njihovih odnosa i
identifikovanog skupa obeležja. Tekstualni opis:

    ● Biblioteka se jedinstveno identifikuje preko svog naziva, a postoje podaci o adresi i broju telefona. Biblioteka ima bar jednu, a
    može da ima i više knjiga za izdavanje. Knjiga se identifikuje preko svog ID broja i naziva biblioteke, a postoji i naziv knjige.

    ● Svaka knjiga ima najmanje jednog autora, a može da ima i više autora. Jedan autor mogao je da napiše više knjiga. Svaki autor
    jedinstveno se identifikuje preko ID autora, a postoje podaci o njegovom imenu, prezimenu, datumu rođenja i eventualno
    datumu smrti.

    ● Svaka knjiga pripada određenoj kategoriji. Kategorija se identifikuje preko svog naziva. Moguće kategorije su: istorija, fantastika,
    IT, strana književnost, srpska književnost. Knjiga pripada tačno jednoj kategoriji, a jednoj kategoriji može da pripada nijedna ili
    više knjiga.

    ● Biblioteka ima jednog ili više članova, a jedan član pripada tačno jednoj biblioteci. Svaki član jedinstveno se identifikuje preko
    članskog broja, a postoje podaci o njegovom imenu, prezimenu, adresi i broju telefona.

    ● Član biblioteke iznajmljuje knjige. Član može da iznajmi više knjiga, a može da se desi da trenutno nema zaduženu ni jednu.
    Jedna knjiga u jednom trenutku može da bude iznajmljena samo jednom članu, a može da se desi da knjiga trenutno nije
    nikome iznajmljena. Za svaku pozajmicu pamti se datum iznajmljivanja. Pozajmica se može identifikovati preko datuma
    iznajmljivanja i ID broja knjige.

    ● Član biblioteke plaća članarinu. Članarina zavisi od kategorije člana. Moguće kategorije su đak, student, radnik, penzioner,
    nezaposlen. Kategorije članova identifikuju se preko naziva. Uz svaku kategoriju navodi se podatak o visini mesečne članarine.
    Svaki član pripada samo jednoj kategoriji članova u datom trenutku, a jednoj kategoriji može da ne pripada ni jedan član, ili da
    pripada više članova.

    ● Obezbediti čuvanje evidencije o svim plaćanjima članova.


| Mnemonik | Pun opis                    | Mnemonik | Pun opis                          |
|----------|-----------------------------|----------|----------------------------------|
| NAZIVB   | Naziv biblioteke            | CLBROJ   | Članski broj člana biblioteke      |
| ADRESA   | Adresa biblioteke           | IMECL    | Ime člana biblioteke              |
| BRTEL    | Broj telefona biblioteke    | PRZCL    | Prezime člana biblioteke          |
| IDK      | Identifikacioni broj knjige | ADRCL    | Adresa člana biblioteke           |
| NAZK     | Naziv knjige                | BRTELCL  | Broj telefona člana biblioteke    |
| IDAUTOR  | Identifikacioni broj autora | DATIZN   | Datum iznajmljivanja knjige       |
| IMEA     | Ime autora                  | NAZKATCL | Naziv kategorije člana biblioteke |
| PREZA    | Prezime autora              | VISCLAN  | Visina mesečne članarine          |
| DATUMR   | Datum rođenja autora        | IZNOS    | Iznos uplate članarine            |
| DATUMS   | Datum smrti autora (opciono)| DATUMPL  | Datum plaćanja članarine          |
| NAZKATK  | Naziv kategorije knjige     |          |                                  |



