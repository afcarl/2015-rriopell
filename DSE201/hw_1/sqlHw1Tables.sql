-- Create tables for customers, students and enrollment
CREATE TABLE customers (
    id          SERIAL PRIMARY KEY,
    first_name  TEXT Not Null,
    last_name   TEXT,
    address		TEXT,
    state_of_residence integer references states(id) Not Null

);

CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    name        TEXT Not Null,
    list_price  MONEY
);

CREATE TABLE states (
    id          SERIAL PRIMARY KEY,
    name        TEXT Not Null,
    abbrev   	TEXT
);


CREATE TABLE product_category (
	id			SERIAL PRIMARY KEY,
	name 		TEXT Not Null,
	description	TEXT
);


CREATE TABLE is_from (
	id 			SERIAL PRIMARY KEY,
	customer	integer	references customers (id) Not Null,
	state 		integer references states (id)	Not Null 
);



CREATE TABLE sales (
	id 			SERIAL PRIMARY KEY,
	product		integer	references products (id) Not Null,
	customers 	integer references customers(id) Not Null, 
	price_paid	money Not Null,
	is_discount	bit	Not Null,
	purschase_date date Not Null,
	state 		integer references states(id) Not Null
);

