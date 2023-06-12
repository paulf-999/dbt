!SET variable_substitution=true;
USE ROLE &{PROGRAM}_&{ENV}_DATA_LOADER;
USE WAREHOUSE &{PROGRAM}_&{ENV}_LOADING_WH;
USE DATABASE &{PROGRAM}_EG_PROJECT3_DB;

CREATE OR REPLACE TABLE production.EG_PROJECT3_categories (
	category_id INT,
	category_name VARCHAR (255) NOT NULL,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE production.EG_PROJECT3_brands (
	brand_id INT,
	brand_name VARCHAR (255) NOT NULL,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE production.EG_PROJECT3_products (
	product_id INT,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE production.EG_PROJECT3_stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE sales.EG_PROJECT3_customers (
	customer_id INT,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5),
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE sales.EG_PROJECT3_orders (
	order_id INT,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE sales.EG_PROJECT3_order_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE sales.EG_PROJECT3_staffs (
	staff_id INT,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);

CREATE OR REPLACE TABLE sales.EG_PROJECT3_stores (
	store_id INT,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5),
	data_src VARCHAR (100) NOT NULL,
	load_ts TIMESTAMP_NTZ(9) NOT NULL
);
