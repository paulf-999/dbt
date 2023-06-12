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
