-- DSE 201 Databases 
-- HW #2, Sales Queries
--Student- Ryan Riopelle

-- Problem 1. Show the total sales (quantity sold and dollar value) for each customer.

SELECT 
  sum(quantity) as sum_quantity, sum(price) as sum_price, customer.customer_name
FROM 
  sales.sale, 
  sales.customer
WHERE 
  customer.customer_id = sale.customer_id
Group By 
  customer.customer_id;

-- 2. Show the total sales for each state.

SELECT 
  state.state_name, sum(sale.price) as sum_sales
FROM 
  sales.customer, 
  sales.sale, 
  sales.state
WHERE 
  customer.customer_id = sale.customer_id AND
  state.state_id = customer.state_id
Group By 
  state.state_id;


-- 3. Show the total sales for each product, for a given customer. Only products that were actually
-- bought by the given customer. Order by dollar value.

SELECT 
    c.customer_name, p.product_name, sum(s.price)  as sumprice
FROM 
  sales.customer c, 
  sales.product p, 
  sales.sale s
WHERE 
  c.customer_id = 1 AND
  p.product_id = s.product_id
Group By
  c.customer_name, p.product_name
Order By
  sumprice;


-- 4. Show the total sales for each product and customer. Order by dollar value.
--?? How is this different than 3?

SELECT 
    c.customer_name, p.product_name, sum(s.price)  as sumprice, sum (sale.quantity) as sum_quant
FROM 
  sales.customer c, 
  sales.product p, 
  sales.sale s
WHERE 
  c.customer_id = s.customer_id AND
  p.product_id = s.product_id
Group By
  c.customer_name, p.product_name
Order By
  c.customer_name, sumprice;


-- 5. Show the total sales for each product category and state. 
--list the sales for each category in each state.

 
SELECT 
  category.category_name, state.state_name, sum(sale.price) as sum_price, sum (sale.quantity) as sum_quant
FROM 
  sales.customer, 
  sales.sale, 
  sales.category, 
  sales.product, 
  sales.state
WHERE 
  customer.customer_id = sale.customer_id AND
  category.category_id = product.category_id AND
  product.product_id = sale.product_id AND
  state.state_id = customer.state_id
Group By
  category.category_name, state.state_name
;


-- 6. For each one of the top 20 product categories and top 20 customers, it returns a tuple (top
-- product, top customer, quantity sold, dollar value


SELECT 
  category_name, sum(sale.price) as sum_price, sum (sale.quantity) as sum_quant
FROM 
  sales.customer, 
  sales.sale, 
  sales.category, 
  sales.product, 
  sales.state
WHERE 
  customer.customer_id = sale.customer_id AND
  category.category_id = product.category_id AND
  product.product_id = sale.product_id AND
  state.state_id = customer.state_id
Group By
  category.category_name
Order By
  sum_price
LIMIT 10
;


-- Below chooses the top 20 product IDs

SELECT 
  sale.product_id, sum(sale.quantity) as sum_quant, sum(sale.price) as sum_price
FROM 
  sales.sale, 
  sales.product
WHERE 
  sale.product_id = product.product_id
Group By
  sale.product_id
Order By
  sum_price DESC
Limit 20


SELECT 
  sale.customer_id, sum(sale.quantity) as sum_quant, sum(sale.price) as sum_price
FROM 
  sales.sale, 
  sales.customer
WHERE 
  customer.customer_id = sale.customer_id
Group By 
  sale.customer_id
Order By
  sum_price DESC
Limit 20
  ;
