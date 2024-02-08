#!/bin/bash
# shellcheck disable=SC1090

#=======================================================================
# Variables
#=======================================================================
SOURCE_GIT_BRANCH_NAME=${1}
CICD_SCRIPTS_DIR=src/cicd/scripts

#=======================================================================
# Functions
#=======================================================================
# Read in common logging functions
source ${CICD_SCRIPTS_DIR}/common/common_cicd_functions.sh

# Read in the functions from the separate script (make the code easier to read/modularise the code)
source ${CICD_SCRIPTS_DIR}/dbt/dbt_slim_ci_pipeline_scripts/main_functions_for_slim_ci_job.sh "${SOURCE_GIT_BRANCH_NAME}"

#=======================================================================
# Main script logic
#=======================================================================

# Run common date/time execution script
source ${CICD_SCRIPTS_DIR}/common/common_date_time_scr_execution.sh

# Validate the inputs for the shell script
validate_input_args "${SOURCE_GIT_BRANCH_NAME}"

# Step 1: On the master branch, let's generate the manifest.json file to understand the state of the dbt project BEFORE the proposed changes"
print_section_header "$DEBUG" "Step 1: Generate dbt manifest.json file for the MASTER branch"
generate_manifest_on_master_branch "${DBT_PROD_RUN_ARTIFACTS_DIR}"

# Step 2: On the feature branch, let's generate the manifest.json file to understand the state of the dbt project INCLUDING the proposed changes
print_section_header "$DEBUG" "Step 2: Generate dbt manifest.json file for the FEATURE branch"
generate_manifest_on_feature_branch

# Step 3: (Conditionally) orchestrate the dbt slim CI job
print_section_header "$DEBUG" "Step 3: Determine if the dbt slim CI job should run based on whether there are any new/modified dbt models."
orchestrate_dbt_slim_ci_job "${SOURCE_GIT_BRANCH_NAME}"
