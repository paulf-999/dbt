#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# Read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

WORKING_DIR=${1} # current working directory
DBT_PROFILE_DIR="<DBT_PROJECT_DIRECTORY_NAME>/profiles" # path to dbt profiles dir
JINJA_CLI_CMD="j2 src/jinja_templates/dbt_profiles/cicd_profiles.yml.j2 -o '${DBT_PROFILE_DIR}/profiles.yml'"

#=======================================================================
# Main script logic
#=======================================================================

# Include script to output date/time of script execution
source src/cicd/scripts/common/common_date_time_scr_execution.sh

# Step 1: Render the dbt cicd_profiles.yml template
log_message "${DEBUG}# Step 1: Render the dbt cicd_profiles.yml template."
log_message "${DEBUG_DETAILS}# Command: ${JINJA_CLI_CMD}"
eval "${JINJA_CLI_CMD}" && echo

# Step 2: Print out the (masked) contents of the generated profiles.yml file
log_message "${DEBUG}# Step 2: Print out the (masked) contents of the generated profiles.yml file" && echo
cat "${DBT_PROFILE_DIR}"/profiles.yml && echo
