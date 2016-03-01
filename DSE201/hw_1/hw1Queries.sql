

--Homework 1 Problem 1

 SELECT 
  customers.first_name,
  SUM(sales.price_paid)
FROM 
  public.products, 
  public.customers, 
  public.sales
WHERE 
  products.id = sales.product AND
  customers.id = sales.customer
group by
  customers.first_name, customers.last_name;

  -- Problem 2 

  