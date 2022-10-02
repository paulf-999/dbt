# Usage:
# make installations	# install the package for the first time, managing dependencies & performing a housekeeping cleanup too
# make deps		# just install the dependencies
# make install		# just perform the install
# make clean		# perform a housekeeping cleanup

.EXPORT_ALL_VARIABLES:

.PHONY = installations deps clean install get_ips init_dbt_project validate_db_connection install_packages gen_schema_w_codegen gen_dbt_sql_objs

CONFIG_FILE := ip/config.json
# the 2 vars below are just for formatting CLI message output
COLOUR_TXT_FMT_OPENING := \033[0;33m
COLOUR_TXT_FMT_CLOSING := \033[0m

installations: clean deps install

deps: get_ips
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'deps'. Download the relevant pip package dependencies (note: ignore the pip depedency resolver errors.)${COLOUR_TXT_FMT_CLOSING}"
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@pip3 install -rq requirements.txt
	@pip3 uninstall keyring -qy && pip3 install keyring -q # there is a module conflict here that otherwise throws a warning
	@pip3 install --upgrade dbt-snowflake==${DBT_VERSION} -q

install: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'install'. Run the setup and install targets.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	# Step 1
	@make -s init_dbt_project
	@echo
	# Step 2
	@make -s validate_db_connection
	@echo
	# Step 3
	@make -s install_packages
	@echo
	# Step 4
	@make -s gen_schema_w_codegen
	# Step 5: 'Code Generation Workflow'
	@make -s gen_dbt_sql_objs

get_ips:
	@# Target: 'get_ips'. Get input args from ip/config.json
	$(eval ENV=$(shell jq -r '.GeneralParameters.Env' ${CONFIG_FILE}))
	$(eval DBT_VERSION=$(shell jq -r '.GeneralParameters.DbtVersion' ${CONFIG_FILE}))
	$(eval DATA_DICTIONARY_NAME=$(shell jq -r '.GeneralParameters.DataDictionaryName' ${CONFIG_FILE}))
	$(eval DIVISION=$(shell jq -r '.GeneralParameters.Division' ${CONFIG_FILE}))
	$(eval DBT_PROFILE_NAME=$(shell jq -r '.DbtParameters.DbtProfileName' ${CONFIG_FILE}))
	$(eval DBT_PROJECT_NAME=$(shell jq -r '.DbtParameters.DbtProjectName' ${CONFIG_FILE}))
	$(eval DBT_MODEL=$(shell jq -r '.DbtParameters.DbtModel' ${CONFIG_FILE}))
	$(eval PROGRAM=$(shell jq -r '.DbtParameters.Program' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_ACCOUNT=$(shell jq -r '.SnowflakeParameters.SnowflakeAccount' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_USER=$(shell jq -r '.SnowflakeParameters.SnowflakeUsername' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_PRIVATE_FILE=$(shell jq -r '.SnowflakeParameters.SnowflakePrivateKey' ${CONFIG_FILE}))

#############################################################################################
# Targets used for dbt project setup
#############################################################################################
init_dbt_project: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'init_dbt_project'. Initialise the DBT project.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@# remove any dbt project files if they already exist
	@rm -rf ${DBT_PROJECT_NAME}
	@[ "${DBT_PROJECT_NAME}" ] || ( echo "\nError: DBT_PROJECT_NAME variable is not set\n"; exit 1 )
	# Step 1: Initialise the DBT project
	@echo
	dbt init ${DBT_PROJECT_NAME} --skip-profile-setup
	@# copy profiles, macros & prereq dirs into DBT project folder
	make -s copy_templates_into_dbt_project
	@echo
	# Step 2: Generate the profiles.yml file
	@echo
	@j2 ${DBT_PROJECT_NAME}/profiles/profiles.yml.j2 -o ${DBT_PROJECT_NAME}/profiles/profiles.yml
	@rm -r ${DBT_PROJECT_NAME}/models/example
	# Step 3: Setup the dbt_project file
	@echo
	@j2 templates/jinja_templates/dbt_project.yml.j2 -o ${DBT_PROJECT_NAME}/dbt_project.yml
	# Step 4: Change permissions of the dbt project folder (otherwise you run into perms issues, re: logs)
	@chmod -R 777 ${DBT_PROJECT_NAME}

copy_templates_into_dbt_project: get_ips
	@cp -r templates/docs/ ${DBT_PROJECT_NAME}/docs/
	@cp -r templates/macros/ ${DBT_PROJECT_NAME}/macros/
	@cp -r templates/profiles/ ${DBT_PROJECT_NAME}/profiles/
	@cp -r templates/target/ ${DBT_PROJECT_NAME}/target/
	@cp -r templates/tmp/ ${DBT_PROJECT_NAME}/tmp/
	@cp -r templates/style_guides/ ${DBT_PROJECT_NAME}/style_guides/
	@cp templates/packages.yml ${DBT_PROJECT_NAME}

#############################################################################################
# dbt-specific commands
#############################################################################################
validate_db_connection: get_ips
	@echo "-----------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'validate_db_connection'. Verify connection to the source DB.${COLOUR_TXT_FMT_CLOSING}"
	@echo "-----------------------------------------------------------------------"
	@echo
	cd ${DBT_PROJECT_NAME} && dbt debug --profiles-dir=profiles

install_packages: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'install_packages'. Install the desired DBT packages.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@cd ${DBT_PROJECT_NAME} && dbt deps --profiles-dir=profiles

gen_schema_w_codegen: get_ips
	@echo "--------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'gen_schema_w_codegen'. Generate the dbt schema.yml file using dbt-codegen.${COLOUR_TXT_FMT_CLOSING}"
	@echo "--------------------------------------------------------------------------------------"
	@cd ${DBT_PROJECT_NAME} && dbt run-operation generate_source --args '{"schema_name": "shared", "database_name": "${DIVISION}_dev", "name": "${DIVISION}", "generate_columns": "true", "include_descriptions": "true"}' --profiles-dir=profiles > schema.yml
	@echo -e "version: 2\n" > ${DBT_PROJECT_NAME}/models/schema.yml
	@tail -n +5 ${DBT_PROJECT_NAME}/schema.yml >> ${DBT_PROJECT_NAME}/models/schema.yml
	@rm ${DBT_PROJECT_NAME}/schema.yml

gen_dbt_sql_objs: get_ips
	@echo "-------------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'gen_dbt_sql_objs'. Generate snapshot/incremental .sql files using Jinja templates.${COLOUR_TXT_FMT_CLOSING}"
	@echo "-------------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}# Generate sql for the 'snapshots' layer.${COLOUR_TXT_FMT_CLOSING}"
	@echo "---------------------------------------------------------------"
	@python3 py/gen_dbt_sql_objs.py ${DATA_DICTIONARY_NAME} snapshots
	@echo "---------------------------------------------------------------"
	@cp -r op/${DIVISION}/snapshots/ dbt_${DIVISION}/
	@echo -e "${COLOUR_TXT_FMT_OPENING}# Generate sql for the 'incremental' layer.${COLOUR_TXT_FMT_CLOSING}"
	@echo "---------------------------------------------------------------"
	@python3 py/gen_dbt_sql_objs.py ${DATA_DICTIONARY_NAME} incremental
	@cp -R op/${DIVISION}/incremental/ dbt_${DIVISION}/models/rds/

run_model: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'run_model'. Run the DBT model.${COLOUR_TXT_FMT_CLOSING}"
	$(info [+] Run the DBT model.)
	@echo "------------------------------------------------------------------"
	@cd ${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --models ${DBT_MODEL}

clean:
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@rm -rf op/bun/snapshots/*.sql && rm -rf op/bun/incremental/*.sql
	@rm -rf op/cat/snapshots/*.sql && rm -rf op/cat/incremental/*.sql
	@rm -rf op/kmt/snapshots/*.sql && rm -rf op/kmt/incremental/*.sql
	@rm -rf op/ofw/snapshots/*.sql && rm -rf op/ofw/incremental/*.sql
	@rm -rf op/tgt/snapshots/*.sql && rm -rf op/tgt/incremental/*.sql
