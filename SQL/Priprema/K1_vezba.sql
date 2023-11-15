--1. Prikazati proizvode (products.product_name, products.standard_cost,
--products.list_price) sortirane po prodajnoj ceni rastuće i nabavnoj ceni opadajuće
SELECT product_name,standard_cost,list_price
    FROM products
    ORDER BY list_price,standard_cost DESC;

--2. Prikazati proizvode (products.product_name, products.description) i razlike
--između prodajne i nabavne cene za proizvode čiji nazivi počinju sa 'Intel'.
SELECT product_name,description,list_price - standard_cost
    FROM products
    WHERE product_name LIKE 'Intel%';

--3. Iz tabele order_items obrisati kolonu unit_price.
ALTER TABLE order_items
DROP COLUMN unit_price;

--4. U tabeli locations izmeniti kolonu city tako da vrednosti u njoj budu u obliku
--<city> (<state>) za lokacije koje u polju state nemaju null vrednosti.
UPDATE locations SET city = city || '(' || state || ')'
    WHERE state IS NOT NULL;

--5. Prikazati imena i prezimena radnika (employees.first_name,
--employees.last_name) koji su povezani sa narudžbinama čiji je status 'Canceled'.
    --1. Nacin
    SELECT DISTINCT first_name,last_name
        FROM employees e,orders o
        WHERE employee_id = salesman_id and o.status = 'Canceled';

    --2.Nacin