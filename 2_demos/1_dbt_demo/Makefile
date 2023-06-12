SHELL = /bin/sh

export DBT_PROFILE_NAME=dbt_svc_profile
export DBT_PROJECT_NAME=bikestores
export DBT_MODEL=curated_db
export PROGRAM=BIKESTORES

validate_conn:
	$(info [+] Verify the connection to the source DB)
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt debug --profiles-dir=profiles

run_model:
	$(info [+] Run the DBT model)
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt run --model ${DBT_MODEL} --profiles-dir profiles

run_incremental_model:
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt run --model ${DBT_MODEL} tag:incremental --profiles-dir profiles

run_snapshots:
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt snapshot --profiles-dir profiles

document_model:
	$(info [+] Document the DBT model)
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt docs generate --profiles-dir profiles --model ${DBT_MODEL}
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt docs serve --profiles-dir profiles

run_generic_tests:
	$(info [+] Test the DBT model. Note: this tests the actual data against predefined business rules)
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt test --schema --profiles-dir profiles

run_bespoke_tests:
	$(info [+] Test the DBT model. Note: this is a schema test only and is useful only for loading new data (enforces uniqueness))
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt test --profiles-dir profiles --model ${DBT_MODEL}

test_and_build:
	$(info [+] Test then if successful, build the DBT model)
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt test --profiles-dir profiles --model ${DBT_MODEL}
	# following successful DBT tests, then run the DBT model
	cd bin/dbt/${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --model ${DBT_MODEL}
