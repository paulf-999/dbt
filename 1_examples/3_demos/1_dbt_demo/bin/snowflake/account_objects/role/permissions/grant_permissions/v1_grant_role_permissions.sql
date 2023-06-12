!SET variable_substitution=true;
-- Grant future ownership of schemas, tables and views to '&{PROGRAM}_DBA' role
USE ROLE SECURITYADMIN;
GRANT OWNERSHIP ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE TABLES IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DBA;
GRANT OWNERSHIP ON FUTURE VIEWS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DBA;

--raw db
GRANT USAGE ON DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DBA;
GRANT USAGE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON ALL STAGES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON ALL STAGES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON ALL FILE FORMATS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON ALL FILE FORMATS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT SELECT ON ALL TABLES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON ALL VIEWS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON ALL EXTERNAL TABLES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON ALL EXTERNAL TABLES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT SELECT ON ALL MATERIALIZED VIEWS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT CREATE TABLE, CREATE EXTERNAL TABLE, CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE TASK ON ALL SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT CREATE TABLE, CREATE EXTERNAL TABLE, CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE TASK ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON FUTURE STAGES IN SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON FUTURE STAGES IN SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_DBA;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT SELECT ON FUTURE TABLES IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE &{PROGRAM}_RAW_DB TO ROLE &{PROGRAM}_DATA_LOADER;

--curated db
GRANT USAGE ON DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE MATERIALIZED VIEW, CREATE PROCEDURE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON ALL TABLES IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON ALL VIEWS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE TABLES IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE VIEWS IN DATABASE &{PROGRAM}_CURATED_DB TO ROLE &{PROGRAM}_DEVELOPER;

--analytics db
GRANT USAGE ON DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE TABLES IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;
GRANT SELECT ON FUTURE VIEWS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_DEVELOPER;

--warehouse perms
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_DEVELOPER_WH TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_DEVELOPER_WH TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_WH TO ROLE &{PROGRAM}_DEVELOPER;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_WH TO ROLE &{PROGRAM}_DATA_LOADER;
--permission below is required, as tasks need to be executed by the DBA role. So the DBA role will require access to the WH
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_WH TO ROLE &{PROGRAM}_DBA;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_LRG_WH TO ROLE &{PROGRAM}_DBA;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_LOADING_WH TO ROLE &{PROGRAM}_DATA_LOADER;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_REPORTING_WH TO ROLE &{PROGRAM}_VISUALISER;
--ACCOUNTADMIN role requires access to the warehouses, in order to alter / create resource monitors
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_DEVELOPER_WH TO ROLE ACCOUNTADMIN;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_WH TO ROLE ACCOUNTADMIN;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_TRANSFORMATION_LRG_WH TO ROLE ACCOUNTADMIN;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_LOADING_WH TO ROLE ACCOUNTADMIN;
GRANT USAGE, OPERATE ON WAREHOUSE &{PROGRAM}_REPORTING_WH TO ROLE ACCOUNTADMIN;
--&{PROGRAM}_VISUALISER role perms
GRANT USAGE ON DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT SELECT ON ALL TABLES IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT SELECT ON ALL VIEWS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT SELECT ON FUTURE TABLES IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;
GRANT SELECT ON FUTURE VIEWS IN DATABASE &{PROGRAM}_ANALYTICS_DB TO ROLE &{PROGRAM}_VISUALISER;