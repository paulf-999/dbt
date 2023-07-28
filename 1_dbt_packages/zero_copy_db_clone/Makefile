SOURCE_DB=example_source_db
TARGET_DB=example_target_db
TARGET_ROLE=example_role

clone_db:
	dbt run-operation clone_database \
	--args "{'source_database': '${SOURCE_DB}', 'destination_database': '${TARGET_DB}', 'new_owner_role': ${TARGET_ROLE}}"
