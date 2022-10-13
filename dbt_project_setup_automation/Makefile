# Usage:
# make installations	# install the package for the first time, managing dependencies & performing a housekeeping cleanup too
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

.EXPORT_ALL_VARIABLES:

.PHONY = installations deps clean install get_ips init_dbt_project validate_db_connection install_packages gen_schema_w_codegen gen_dbt_sql_objs

CONFIG_FILE := ip/config.yaml
# the 2 vars below are just for formatting CLI message output
COLOUR_TXT_FMT_OPENING := \033[0;33m
COLOUR_TXT_FMT_CLOSING := \033[0m

installations: clean deps install

deps: get_ips
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'deps'. Download the relevant pip package dependencies (note: ignore the pip depedency resolver errors.)${COLOUR_TXT_FMT_CLOSING}"
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@pip3 install -q -r requirements.txt
	@pip3 uninstall keyring -qy && pip3 install keyring -q # there is a module conflict here that otherwise throws a warning
	@pip3 install --upgrade dbt-snowflake==${DBT_VERSION} -q

install: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'install'. Run the setup and install targets.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	# Step 1: remove any previously generated files
	@make -s clean
	# Step 2: Initialise the dbt project
	@make -s init_dbt_project
	@echo
	# Step 3: Verify connection to the source DB
	@make -s validate_db_connection
	@echo
	# Step 4: Install the desired dbt packages
	@make -s install_packages
	@echo
	# Step 5: 'Code Generation Workflow': Generate the dbt source.yml (source properties) file
	@make -s gen_source_properties_file
	@echo "--------------------------------"
	@echo
	# Step 6: 'Code Generation Workflow': Generate the snapshot/incremental .sql files using Jinja templates
	@echo
	@make -s gen_dbt_sql_objs
	@echo -e "\n------------------------------------------------------------------"
	@echo "Finished! Check the newly created dbt project folder: '${DBT_PROJECT_NAME}'"
	@echo -e "------------------------------------------------------------------\n"

get_ips:
	@# Target: 'get_ips'. Get input args from ip/config.json
	@# general params
	$(eval ENV=$(shell yq -r '.general_params.env' ${CONFIG_FILE}))
	$(eval DATA_SRC=$(shell yq -r '.general_params.data_src' ${CONFIG_FILE}))
	@# db_connection params
	$(eval SNOWFLAKE_ACCOUNT=$(shell yq -r '.db_connection_params.snowflake_account' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_USERNAME=$(shell yq -r '.db_connection_params.snowflake_username' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_PRIVATE_FILE=$(shell yq -r '.db_connection_params.snowflake_private_key' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_WH=$(shell yq -r '.db_connection_params.snowflake_warehouse' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_ROLE=$(shell yq -r '.db_connection_params.snowflake_role' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_DB=$(shell yq -r '.db_connection_params.snowflake_data_src_db' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_DB=$(shell yq -r '.db_connection_params.snowflake_src_db' ${CONFIG_FILE}))
	$(eval SNOWFLAKE_SCHEMA=$(shell yq -r '.db_connection_params.snowflake_src_db_schema' ${CONFIG_FILE}))
	@# dbt params
	$(eval DBT_VERSION=$(shell yq -r '.dbt_params.dbt_version' ${CONFIG_FILE}))
	$(eval DBT_PROFILE_NAME=$(shell yq -r '.dbt_params.dbt_profile_name' ${CONFIG_FILE}))
	$(eval DBT_PROJECT_NAME=$(shell yq -r '.dbt_params.dbt_project_name' ${CONFIG_FILE}))
	$(eval DBT_MODEL=$(shell yq -r '.dbt_params.dbt_model' ${CONFIG_FILE}))
	$(eval PROGRAM=$(shell yq -r '.dbt_params.program' ${CONFIG_FILE}))

#############################################################################################
# Targets used for dbt project setup
#############################################################################################
init_dbt_project: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'init_dbt_project'. Initialise the dbt project.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@[ "${DBT_PROJECT_NAME}" ] || ( echo "\nError: DBT_PROJECT_NAME variable is not set\n"; exit 1 )
	# Step 1: Initialise the dbt project. dbt project name = '${DBT_PROJECT_NAME}'.
	@echo
	dbt init ${DBT_PROJECT_NAME} --skip-profile-setup
	@echo
	# Step 2: copy profiles, macros & prereq dirs into dbt project folder
	@make -s copy_templates_into_dbt_project
	@echo
	# Step 3: Generate the profiles.yml file
	@echo
	@j2 ${DBT_PROJECT_NAME}/profiles/profiles.yml.j2 -o ${DBT_PROJECT_NAME}/profiles/profiles.yml
	@rm -r ${DBT_PROJECT_NAME}/models/example
	# Step 4: Setup the dbt_project.yml file
	@echo
	@j2 templates/jinja_templates/dbt_project.yml.j2 -o ${DBT_PROJECT_NAME}/dbt_project.yml
	# Step 5: create a folder in the dbt project for the target model
	@echo
	@mkdir ${DBT_PROJECT_NAME}/models/${DATA_SRC}_${DBT_MODEL}
	@echo
	# TODO - render the templates/jina_templates/models here
	@echo
	# Step 6: Change permissions of the dbt project folder. Otherwise you run into perms issues with the logs/ & target/ folders
	@chmod -R 777 ${DBT_PROJECT_NAME}

copy_templates_into_dbt_project: get_ips
	@cp -r templates/template_dirs/docs/ ${DBT_PROJECT_NAME}/docs/
	@cp -r templates/template_dirs/logs/ ${DBT_PROJECT_NAME}/logs/
	@cp -r templates/template_dirs/macros/ ${DBT_PROJECT_NAME}/
	@cp -r templates/template_dirs/profiles/ ${DBT_PROJECT_NAME}/profiles/
	@cp -r templates/template_dirs/style_guides/ ${DBT_PROJECT_NAME}/style_guides/
	@cp -r templates/template_dirs/target/ ${DBT_PROJECT_NAME}/target/
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
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'install_packages'. Install the desired dbt packages.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@cd ${DBT_PROJECT_NAME} && dbt deps --profiles-dir=profiles

gen_source_properties_file: get_ips
	@echo "-----------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'gen_source_properties_file'. Generate the dbt source.yml (source properties) file.${COLOUR_TXT_FMT_CLOSING}"
	@echo "-----------------------------------------------------------------------"
	@python3 py/gen_source_properties.py
	@# create dir if not exists
	@cp op/${DATA_SRC}/_${DATA_SRC}_source.yml ${DBT_PROJECT_NAME}/models/${DATA_SRC}_rds/

gen_schema_w_codegen: get_ips
	# TODO: troubleshoot this
	@echo "--------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'gen_schema_w_codegen'. Generate the dbt schema.yml file using dbt-codegen.${COLOUR_TXT_FMT_CLOSING}"
	@echo "--------------------------------------------------------------------------------------"
	cd ${DBT_PROJECT_NAME} && dbt run-operation generate_source --args '{"schema_name": "shared", "database_name": "${DATA_SRC}_dev", "name": "${DATA_SRC}", "generate_columns": "true", "include_descriptions": "true"}' --profiles-dir=profiles > schema.yml
	@echo -e "version: 2\n" > ${DBT_PROJECT_NAME}/models/schema.yml
	@tail -n +5 ${DBT_PROJECT_NAME}/schema.yml >> ${DBT_PROJECT_NAME}/models/schema.yml
	@rm ${DBT_PROJECT_NAME}/schema.yml

gen_dbt_sql_objs: get_ips
	@echo "-------------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'gen_dbt_sql_objs'. Generate snapshot/incremental .sql files using Jinja templates.${COLOUR_TXT_FMT_CLOSING}"
	@echo "-------------------------------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}# Generate sql for the 'snapshots' layer.${COLOUR_TXT_FMT_CLOSING}"
	@echo "---------------------------------------------------------------"
	@python3 py/gen_dbt_sql_objs.py snapshot
	@echo "---------------------------------------------------------------"
	@mkdir ${DBT_PROJECT_NAME}/snapshots/${DATA_SRC}/
	@cp -R op/${DATA_SRC}/snapshot/*.sql ${DBT_PROJECT_NAME}/snapshots/${DATA_SRC}
	@echo -e "${COLOUR_TXT_FMT_OPENING}# Generate sql for the 'incremental' layer.${COLOUR_TXT_FMT_CLOSING}"
	@echo "---------------------------------------------------------------"
	@python3 py/gen_dbt_sql_objs.py incremental
	@cp -R op/${DATA_SRC}/incremental/*.sql ${DBT_PROJECT_NAME}/models/${DATA_SRC}rds/

run_model: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target: 'run_model'. Run the dbt model.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@cd ${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --models ${DBT_MODEL}

clean: get_ips
	@echo "------------------------------------------------------------------"
	@echo -e "${COLOUR_TXT_FMT_OPENING}Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_TXT_FMT_CLOSING}"
	@echo "------------------------------------------------------------------"
	@# remove any dbt project files if they already exist
	@rm -rf ${DBT_PROJECT_NAME}
