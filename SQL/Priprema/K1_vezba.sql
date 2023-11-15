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
    SELECT first_name,last_name
    FROM employees
    WHERE employee_id IN (SELECT salesman_id FROM orders WHERE status = 'Canceled');

    --3. Nacin
    WITH canceled_rad AS(
        SELECT salesman_id FROM orders WHERE status = 'Canceled')
    SELECT DISTINCT first_name,last_name
        FROM employees,canceled_rad cr
        WHERE employee_id = cr.salesman_id;

--6. Prikazati podatke o radnicima (employees.first_name, employees.last_name,
--employees.job_title) koji nisu nikome nadređeni.

SELECT first_name,last_name,job_title
    FROM employees
    WHERE employee_id NOT IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL);

--7. Prikazati podatke o skladištima (location.address,
--warehouses.warehouse_name) za skladišta koja nisu u Sjedinjenim Američkim Državama.

SELECT l.address,w.warehouse_name
    FROM locations l INNER JOIN warehouses w ON l.location_id = w.location_id
    WHERE country_id != ('US');

--8. Prikazati podatke o porudžbinama (orders.order_id, orders.order_date) kao i ukupnu zaradu od porudžbine (suma razlika prodajnih i nabavnih cena prozvoda
--pomnoženih količinom proizvoda u stavci porudžbine) za porudžbine koje imaju manje od 4 stavke.
    --1. Nacin
    WITH broj_stavki AS(
        SELECT order_id, COUNT(order_id) AS broj
            FROM order_items
            GROUP BY order_id)
    SELECT o.order_id,o.order_date,SUM((p.list_price-p.standard_cost)*oi.quantity) Zarada
        FROM orders o INNER JOIN order_items oi ON o.order_id = oi.order_id
                    INNER JOIN products p ON oi.product_id = p.product_id  
                    INNER JOIN broj_stavki bs ON oi.order_id = bs.order_id
        WHERE bs.broj < 4
        GROUP BY o.order_id,o.order_date;
        