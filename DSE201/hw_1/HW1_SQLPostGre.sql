CREATE TABLE customers (
    id          SERIAL PRIMARY KEY,
    first_name  TEXT,
    last_name   TEXT
 );
CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    name        TEXT,
    list_price  TEXT
);

CREATE TABLE product_category (
     id		SERIAL PRIMARY KEY,
     name 		TEXT,
     description	TEXT
);