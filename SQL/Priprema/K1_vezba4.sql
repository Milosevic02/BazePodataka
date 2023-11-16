--1. Prikazati države (IDD, NAZIVD), sortirane u rastućem redosledu naziva države
SELECT idd,nazivd 
    FROM drzava
    ORDER BY nazivd;

--2. Prikazati sve vozače (IDV, IMEV, PREZV) koji u imenu malo slovo ‘n’ ili veliko slovo ‘L’
SELECT idv,imev,prezv
    FROM vozac
    WHERE imev LIKE '%n%' OR imev LIKE '%L%';