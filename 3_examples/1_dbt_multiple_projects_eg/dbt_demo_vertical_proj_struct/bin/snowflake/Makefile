SHELL = /bin/sh

default: create_snowflake_account_objs

config_file=envvars.json

$(eval program=$(shell jq '.Parameters.program' ${config_file}))
$(eval program_upper=$(shell echo $(program) | tr 'a-z' 'A-Z'))
$(eval program_lower=$(shell echo $(program) | tr 'A-Z' 'a-z'))
$(eval env=$(shell jq '.Parameters.environment' ${config_file}))
$(eval sf_conn_profile=$(shell echo $(program) | tr 'A-Z' 'a-z'))
$(eval bootstrap_version=$(shell jq '.Parameters.bootstrap_version' ${config_file}))
$(eval snowsql_version=$(shell jq '.Parameters.snowsql_version' ${config_file}))
$(eval snowsql_installer_path=$(shell jq '.Parameters.snowsql_installer_path' ${config_file}))
$(eval sf_acc_name=$(shell jq '.Parameters.SnowflakeParams.sf_acc_name' ${config_file}))
$(eval sf_username=$(shell jq '.Parameters.SnowflakeParams.sf_username' ${config_file}))
$(eval sf_pass=$(shell jq '.Parameters.SnowflakeParams.sf_pass' ${config_file}))

snowsql_query=snowsql -c ${sf_conn_profile} -o friendly=false -o header=false -o timing=false

create_snowflake_account_objs:
	$(info [+] Create the snowflake account objects)
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	@${snowsql_query} -f account_objects/database/v1_eg_project1_db_and_schemas.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f account_objects/database/v1_eg_project2_db_and_schemas.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f account_objects/database/v1_eg_project3_db_and_schemas.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f account_objects/bespoke_perms.sql --variable program=${program} --variable ENV=${env}

create_snowflake_src_db_objs:
	$(info [+] Create the snowflake NEW db objects)
	@${snowsql_query} -f database_objects/src_db/table/eg_project1/v1_sales_tbls.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/table/eg_project1/v1_production_tbls.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/table/eg_project2/v1_sales_tbls.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/table/eg_project2/v1_production_tbls.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/table/eg_project3/v1_sales_tbls.sql --variable program=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/table/eg_project3/v1_production_tbls.sql --variable program=${program} --variable ENV=${env}

load_ip_data:
	$(info [+] Create stages, upload files to stage then load into target tables)
	@${snowsql_query} -f database_objects/src_db/file_format/v1_csv_file_format.sql --variable PROGRAM=${program} --variable ENV=${env}
	@${snowsql_query} -f database_objects/src_db/stage/v1_bike_shop_stage.sql --variable PROGRAM=${program_upper} --variable ENV=${env}

	# upload the files
	@${snowsql_query} -f data_loading/upload_data.sql --variable PROGRAM=${program} --variable ENV=${env}
	@${snowsql_query} -f data_loading/insert_data_into_raw_production_tbls.sql --variable PROGRAM=${program} --variable ENV=${env}
	@${snowsql_query} -f data_loading/insert_data_into_raw_sales_tbls.sql --variable PROGRAM=${program} --variable ENV=${env}
