-- Table: public.customers

-- DROP TABLE public.customers;

CREATE TABLE public.customers
(
  id integer NOT NULL DEFAULT nextval('customers_id_seq'::regclass),
  first_name text,
  last_name text,
  CONSTRAINT customers_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.customers
  OWNER TO postgres;


-- Table: public.product_category

-- DROP TABLE public.product_category;

CREATE TABLE public.product_category
(
  id integer NOT NULL DEFAULT nextval('product_category_id_seq'::regclass),
  name text,
  description text,
  CONSTRAINT product_category_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.product_category
  OWNER TO postgres;

-- Table: public.products

-- DROP TABLE public.products;

CREATE TABLE public.products
(
  id integer NOT NULL DEFAULT nextval('products_id_seq'::regclass),
  name text,
  list_price text,
  CONSTRAINT products_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.products
  OWNER TO postgres;


-- Table: public.state

-- DROP TABLE public.state;

CREATE TABLE public.state
(
  id integer NOT NULL DEFAULT nextval('state_id_seq'::regclass),
  name text,
  abbrev text,
  CONSTRAINT state_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.state
  OWNER TO postgres;
