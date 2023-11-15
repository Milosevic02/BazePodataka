--1. Prikazati proizvode (products.product_name, products.standard_cost,
--products.list_price) sortirane po prodajnoj ceni rastuće i nabavnoj ceni opadajuće
SELECT product_name,standard_cost,list_price
    FROM products
    ORDER BY list_price,standard_cost DESC;