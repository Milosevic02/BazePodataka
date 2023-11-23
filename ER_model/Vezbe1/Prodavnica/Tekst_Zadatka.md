# Prodavnica

Nacrtati ER konceptualnu šemu baze podataka PRODAVNICA, na osnovu tekstualnog opisa realnih entiteta i njihovih odnosa i
identifikovanog skupa obeležja. Tekstualni opis:

    ● Proizvod ima kod (šifru) - KODPR, naziv - NAZPR.

    ● Prodavac ima šifru - SIFPROD, ime - IMEPROD, prezime - PRZPROD.

    ● Uloga ima šifru – SIFUL i naziv - NAZUL (unos šifri proizvoda, unos pazara). Jednu ulogu može da ima više prodavaca, a ne mora
    ni jedan, dok jedan prodavac ima jednu i samo jednu ulogu.

    ● Kasa se identifikuje preko svog ID broja – IDK.

    ● Račun ima svoj ID broj, a identifikuje se i preko ID broja kase na kojoj je napravljen. Takođe, postoji datum na računu kao i
    ukupan iznos.

    ● Račun ima jednu ili više stavki. Svaka stavka odnosi se na jedan proizvod, a postoji i količina tog proizvoda u okviru stavke, kao i
    iznos te stavke. Stavka se identifikuje na osnovu svog rednog broja - RBRST, u okviru računa. Stavka pripada jednom i samo
    jednom računu.

    ● Svaki proizvod prodaje se po ceni koja je trenutno važeća. Cenovnik ima cenu proizvoda kao i datum početka važenja i
    eventualno datum prestanka važenja. Svaka stavka cenovnika identifikuje se na osnovu šifre proizvoda i datuma početka
    važenja.

    ● Prodavac obrađuje nijedan ili više računa, a jedan račun obrađuje jedan i samo jedan prodavac.

| Kod proizvoda | Naziv proizvoda       |
|---------------|------------------------|
| KODPR         | NAZPR                  |
| KOLPR         | Količina proizvoda     |
| SIFPROD       | Šifra prodavca         |
| IMEPROD       | Ime prodavca           |
| PRZPROD       | Prezime prodavca       |
| IDK           | Identifikacioni broj kase |
| IDR           | Identifikacioni broj računa |
| DATRAC        | Datum izdavanja računa |
| UKIZNOS       | Ukupan iznos računa    |
| RBRST         | Redni broj stavke       |
| KOLPRSTAV     | Količina proizvoda u okviru stavke |
| IZNOS         | Iznos stavke           |
| ŠIFUL         | Šifra uloge            |
| NAZUL         | Naziv uloge            |
| DATPOČ        | Datum početka važenja cenovnika |
| DATPRES       | Datum prestanka važenja cenovnika |
| CENA          | Cena u okviru cenovnika |

