SHELL = /bin/sh

export DBT_PROFILE_NAME=dbt_svc_profile
export DBT_PROJECT_NAME=bike_shop
export DBT_MODEL=curated_db
export PROGRAM=BIKE_SHOP

validate_conn:
	$(info [+] Verify the connection to the source DB)
	cd ${DBT_PROJECT_NAME} && dbt debug --profiles-dir=profiles

run_incremental_model:
	dbt run --model ${DBT_MODEL} tag:incremental --profiles-dir profiles
