--Ryan Riopelle
-- 

SELECT cate.category_id,cust.customer_id,sum(quantity),sum(price) FROM 
(SELECT category_id,sum(price) AS dollar_value FROM
sales.category NATURAL JOIN sales.product NATURAL JOIN sales.sale
GROUP BY category_id ORDER BY dollar_value DESC limit 10) AS cate,
(SELECT customer_id,sum(price) AS dollar_value FROM sales.sale
GROUP BY customer_id ORDER BY dollar_value DESC limit 10) AS cust, sales.sale s,sales.product p
WHERE p.category_id = cate.category_id and s.customer_id = cust.customer_id and s.product_id = p.product_id
GROUP BY cate.category_id,cust.customer_id ORDER BY cate.category_id


SELECT cate.category_id,cust.customer_id,sum(quantity),sum(price) FROM 
(SELECT category_id,sum(price) AS dollar_value FROM
sales.category NATURAL JOIN sales.product NATURAL JOIN sales.sale
GROUP BY category_id ORDER BY dollar_value DESC limit 10) AS cate,
(SELECT customer_id,sum(price) AS dollar_value FROM sales.sale
GROUP BY customer_id ORDER BY dollar_value DESC limit 10) AS cust, sales.sale s,sales.product p
WHERE p.category_id = cate.category_id and s.customer_id = cust.customer_id and s.product_id = p.product_id
GROUP BY cate.category_id,cust.customer_id ORDER BY cate.category_id


--Create precomputed table

Two pre-computed tables were created, one for each subquery: sales.PRE_Category_Sale, sales.PRE_Customer_Sale.

DROP TABLE IF EXISTS sales.PRE_Category_Sale ;
create table sales.PRE_Category_Sale as 
	SELECT category_id,sum(price) AS dollar_value
	FROM sales.category NATURAL
	INNER JOIN sales.product NATURAL
	INNER JOIN sales.sale
	GROUP BY category_id;

DROP TABLE IF EXISTS sales.PRE_Customer_Sale;  
create table sales.PRE_Customer_Sale as 
	SELECT customer_id,sum(price) AS dollar_value
	FROM sales.sale
	GROUP BY customer_id;

--Trigger Tables used 87943

CREATE or replace FUNCTION sales.FN_PRE_Category_Sale() RETURNS trigger AS $FN_PRE_Category_Sale$
    BEGIN
	UPDATE sales.PRE_Category_Sale as pre
		SET dollar_value = pre.dollar_value + NEW.price
	FROM  sales.product as p
	WHERE pre.category_id = p.category_Id
	AND p.product_id =  NEW.product_id;
	IF NOT FOUND THEN
	--no category_id updated
		INSERT INTO sales.PRE_Category_Sale (category_id, dollar_value)
		SELECT p.category_id, NEW.price
		FROM sales.product p
		WHERE p.product_id = NEW.product_id;
	END IF;
	RETURN NEW;
    END;
$FN_PRE_Category_Sale$ LANGUAGE plpgsql;



DROP TRIGGER IF EXISTS trigger_Sale_Category ON sales.sale ;
CREATE TRIGGER trigger_Sale_Category 
BEFORE INSERT ON sales.sale 
FOR EACH ROW EXECUTE PROCEDURE sales.FN_PRE_Category_Sale();



CREATE or replace FUNCTION sales.FN_PRE_Customer_Sale() RETURNS trigger AS $FN_PRE_Customer_Sale$
    BEGIN
	UPDATE sales.PRE_Customer_Sale
		SET dollar_value = dollar_value + NEW.price
	WHERE customer_id = NEW.customer_id;
	
	IF NOT FOUND THEN
	--no category_id updated
		INSERT INTO sales.PRE_Customer_Sale (customer_id, dollar_value)
		SELECT NEW.customer_id, NEW.price;
	END IF;
	RETURN NEW;
    END;
$FN_PRE_Customer_Sale$ LANGUAGE plpgsql;



DROP TRIGGER IF EXISTS trigger_Sale_Customer ON sales.sale ;
CREATE TRIGGER trigger_Sale_Customer
BEFORE INSERT ON sales.sale 
FOR EACH ROW EXECUTE PROCEDURE sales.FN_PRE_Customer_Sale();




-- New Query Using THe Precomputed table

WITH cate AS (SELECT category_id FROM sales.PRE_Category_Sale ORDER BY dollar_value DESC limit 10),cust as (SELECT customer_id
FROM sales.PRE_Customer_Sale ORDER BY dollar_value DESC limit 10) 

SELECT cate.category_id,cust.customer_id,sum(quantity),sum(price)
FROM cate,cust,sales.sale s,sales.product p
WHERE p.category_id = cate.category_id AND s.customer_id = cust.customer_id AND s.product_id = p.product_id
GROUP BY cate.category_id,cust.customer_id
ORDER BY cate.category_id

--indexes

CREATE INDEX pre_category_sale_id_key
ON sales.pre_category_sale 
USING btree
(dollar_value DESC, category_id);

CREATE INDEX category_id_product_id_key
  ON sales.product
  USING btree
  (category_id, product_id);

CREATE INDEX product_id_category_id_key
  ON sales.product
  USING btree
  (product_id, category_id);

CREATE INDEX product_id_quantity_price_id
  ON sales.sale
  USING btree
  (product_id, quantity, price);








