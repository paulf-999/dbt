#================================================================
# Usage
#================================================================
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

#=======================================================================
# Variables
#=======================================================================
include src/make/variables.mk # load variables from a separate makefile file

.EXPORT_ALL_VARIABLES:
#=======================================================================
# Targets
#=======================================================================
all: deps install clean

deps:
	@echo "${INFO}\nCalled makefile target 'deps'. Download any required libraries.${COLOUR_OFF}\n"
	@echo "${DEBUG}deps called"
	# manual step - add bit to dbt_project.yml
	# TODO - grant snowflake perms
	make -s install_package

install_package:
	# add dbt_snowflake_monitoring to dbt packages.yml file
	@bash src/sh/add_dbt_snowflake_monitoring_pkg.sh
	# install dbt_snowflake_monitoring pkg
	@cd ${DBT_PROJECT_DIRECTORY} && dbt deps
	# update the SQL used by the underlying models
	@bash src/sh/update_dbt_models.sh

install:
	@echo "${INFO}\nCalled makefile target 'install'. Run the install targets.\n${COLOUR_OFF}"
	@bash src/sh/run_models_for_dbt_sf_monitoring_pkg.sh

clean:
	@echo "${INFO}\nCalled makefile target 'clean'. Restoring the repository to its initial state.${COLOUR_OFF}\n"

# Phony targets
.PHONY: all deps install install_package clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
