create or replace  function insertValuesCats(num integer) returns void as $$
DECLARE
    user_val integer;
    video_val integer;
    like_val integer;
    i integer;
BEGIN
  i := 1;
  WHILE i <= num LOOP
    execute 'select max(like_id) from cats.likes' into like_val;
    execute 'SELECT trunc(random() * ((select max(user_id) from cats.user)-1) + 1)' into user_val;
    execute 'SELECT trunc(random() * ((select max(video_id) from cats.video)-1) + 1)' into video_val;
    if ((select count(*) from cats.likes where user_id=user_val and video_id=video_val) < 1)
      then
        insert into cats.likes (like_id,user_id,video_id,"time") values (like_val+1,user_val,video_val,now());
        i := i + 1;
    end if;
  END LOOP;
END ;$$ LANGUAGE plpgsql


select insertValuesCats(10);



create or replace  function insertValuesSales(num integer) returns void as $$
DECLARE
    sale_val integer;
    cust_val integer;
    product_val integer;
    quant_val integer;
    price_val integer;
    i integer;
BEGIN
  i := 1;
  WHILE i <= num LOOP
    execute 'select max(sale_id) from sales.sale' into sale_val;
    execute 'SELECT trunc(random() * ((select max(customer_id) from sales.customer)-1) + 1)' into cust_val;
    execute 'SELECT trunc(random() * ((select max(product_id) from sales.product)-1) + 1)' into product_val;
    quant_val := trunc(random() * 14 + 1);
    price_val := random() * 695 + 5;
    insert into sales.sale (sale_id,customer_id,product_id,quantity,price) values (sale_val+1,cust_val,product_val,quant_val,price_val);
    i := i + 1;
  END LOOP;
END ;$$ LANGUAGE plpgsql

select insertValuesSales(10);