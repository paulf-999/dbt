SHELL = /bin/sh

export DBT_PROFILE_NAME=dbt_svc_profile
export DBT_PROJECT_NAME=bike_shop
export DBT_MODEL=curated_db
export PROGRAM=BIKE_SHOP

snowsql_query=snowsql -c ${DBT_PROJECT_NAME} -o friendly=false -o header=false -o timing=false

validate_conn:
	$(info [+] Verify the connection to the source DB)
	cd ${DBT_PROJECT_NAME} && dbt debug --profiles-dir=profiles

write_to_log_demo:
	@echo "[$(shell date)]" 2>&1 | tee  -a logs/dbt_cmds.log && cd ${DBT_PROJECT_NAME} && dbt deps --profiles-dir=profiles 2>&1 | tee  -a  ../../../logs/dbt_cmds.log

run_model_dq_db:
	cd ${DBT_PROJECT_NAME}/dbt_modules/data_quality && dbt run --profiles-dir profiles

run_snapshots:
	cd ${DBT_PROJECT_NAME} && dbt snapshot --profiles-dir dbt_modules/snapshot_cdc_processing/profiles

cdc_demo:
	@${snowsql_query} -f bin/snowflake/data_loading/cdc_demo.sql
	@make run_model_dq_db
	@make run_snapshots

run_dwh_model_raw_db:
	$(info [+] Run the DBT model)
	cd ${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --models raw_db

run_dwh_model_curated_db:
	$(info [+] Run the DBT model)
	cd ${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --models curated_db

document_model:
	$(info [+] Document the DBT model)
	cd ${DBT_PROJECT_NAME} && dbt docs generate --profiles-dir profiles
	cd ${DBT_PROJECT_NAME} && dbt docs serve --profiles-dir profiles
