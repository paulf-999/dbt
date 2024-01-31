SHELL = /bin/sh

#================================================================
# Usage
#================================================================
# make installations	# install the package for the first time, managing dependencies & performing a housekeeping cleanup too
# make deps				# just install the dependencies
# make install			# just perform the install
# make clean			# perform a housekeeping cleanup

.EXPORT_ALL_VARIABLES:

CONFIG_FILE := ip/config.json
DOCKER_COMPOSE_CMD := docker-compose run --rm
DBT_PROFILE := --profiles-dir /work/profiles

.PHONY: installations deps install clean get_ips setup_dbt_project

installations: deps install clean

deps:
	$(info [+] Target: 'deps'. Download the relevant dependencies)
	@pip3 install jq -q
	@pip3 install --upgrade dbt-snowflake==1.0.0
	@pip3 install docker

install:
	$(info [+] Target: 'install'. Run the setup and install targets)
	@make -s setup_dbt_project
	@make -s validate
	@make -s install_packages

clean:
	$(info [+] Target: 'clean'. Remove any redundant files, e.g. downloads)

get_ips:
	@# Target: 'get_ips'. Get input args from ip/config.json
	$(eval ENV=$(shell jq -r '.GeneralParameters.Env' ${CONFIG_FILE}))
	$(eval DBT_PROFILE_NAME=$(shell jq -r '.DbtParameters.DbtProfileName' ${CONFIG_FILE}))
	$(eval DBT_PROJECT_NAME=$(shell jq -r '.DbtParameters.DbtProjectName' ${CONFIG_FILE}))
	$(eval DBT_MODEL=$(shell jq -r '.DbtParameters.DbtModel' ${CONFIG_FILE}))
	$(eval PROGRAM=$(shell jq -r '.DbtParameters.Program' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_ACCOUNT=$(shell jq -r '.SnowflakeParameters.SnowflakeAccount' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_USER=$(shell jq -r '.SnowflakeParameters.SnowflakeUsername' ${CONFIG_FILE}))
	$(eval DBT_SNOWFLAKE_PRIVATE_FILE=$(shell jq -r '.SnowflakeParameters.SnowflakePrivateKey' ${CONFIG_FILE}))

setup_dbt_project: get_ips
	rm -rf ${DBT_PROJECT_NAME}
	@dbt init ${DBT_PROJECT_NAME} --skip-profile-setup
	# copy template profile, macros & packages.yml files into your DBT project folder
	@cp -r templates/profiles ${DBT_PROJECT_NAME} && cp -r templates/macros ${DBT_PROJECT_NAME} && cp templates/packages.yml ${DBT_PROJECT_NAME}
	# populate profiles/profiles.yml with ${DBT_PROFILE_NAME} var
	@j2 templates/profiles/profiles.yml.j2 -o ${DBT_PROJECT_NAME}/profiles/profiles.yml
	# setup the dbt_project file
	@j2 templates/dbt_project.yml.j2 -o ${DBT_PROJECT_NAME}/dbt_project.yml
	@# delete the example project
	@rm -r ${DBT_PROJECT_NAME}/models/example

validate:
	$(info [+] Target: 'validate'. Verify the connection to the source DB)
	${DOCKER_COMPOSE_CMD} dbt debug ${DBT_PROFILE}

install_packages:
	$(info [+] Install the desired DBT packages)
	${DOCKER_COMPOSE_CMD} dbt deps --profiles-dir=profiles

run_model:
	$(info [+] Target: 'run_model'. Run the DBT model)
	${DOCKER_COMPOSE_CMD} dbt run ${DBT_PROFILE} --models ${DBT_MODEL}

test_model:
	$(info [+] Target: 'test_model'. Test the DBT model. Note: this is a schema test only and is useful only for loading new data (enforces uniqueness))
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	dbt test ${DBT_PROFILE}

data_test_model:
	$(info [+] Target: 'data_test_model'. Test the DBT model. Note: this tests the actual data against predefined business rules)
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	dbt test --data ${DBT_PROFILE}

document_model:
	$(info [+] Target: 'document_model'. Document your DBT model)
	dbt docs generate ${DBT_PROFILE}
	dbt docs serve --profiles-dir profiles


#TODO: come back to this later
verify_ips:
	@[ "${ENV}" ] || ( echo "\nError: ENV variable is not set\n"; exit 1 )
	@[ "${DBT_SNOWFLAKE_USER}" ] || ( echo "\nError: DBT_SNOWFLAKE_USER variable is not set\n"; exit 1 )
	@[ "${DBT_SNOWFLAKE_PRIVATE_FILE}" ] || ( echo "\nError: DBT_SNOWFLAKE_PRIVATE_FILE variable is not set\n"; exit 1 )

ifeq ("$(wildcard $(DBT_SNOWFLAKE_USER))","")
	@echo "\nError: You need to provide your Snowflake username inside ip/config.json.\n"; exit 1
endif
ifeq ("$(wildcard $(DBT_SNOWFLAKE_PRIVATE_FILE))","")
	@echo "\nError: You need to provide the path to your Snowflake private key file, inside ip/config.json.\n"; exit 1
endif
