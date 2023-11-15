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

