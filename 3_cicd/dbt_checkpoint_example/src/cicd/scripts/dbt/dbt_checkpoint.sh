#!/bin/bash
#=======================================================================
# Variables
#=======================================================================
CICD_SCRIPTS_DIR=src/cicd/scripts

#=======================================================================
# Functions
#=======================================================================
# read in common logging functions
source ${CICD_SCRIPTS_DIR}/common/common_cicd_functions.sh

run_pre_commit() {
    local HOOK_ID="$1"
    local FULL_COMMAND="pre-commit run --hook-stage commit ${HOOK_ID} --all-files"
    ${FULL_COMMAND}
    local EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        print_section_header "$ERROR" "pre-commit hook '${HOOK_ID}' failed with exit code ${EXIT_CODE}"
        exit 1 # Exit the function with error code 1
    fi
}

#=======================================================================
# Main script logic
#=======================================================================
# Run common date/time execution script
source ./"${CICD_SCRIPTS_DIR}"/common/common_date_time_scr_execution.sh

# Activate the venv
source venv/bin/activate

print_section_header "$DEBUG" "Main Step: use the pre-commit package 'dbt-coverage' to check the dbt standards used"
log_message "${DEBUG_DETAILS}Command = pre-commit run --hook-stage commit '{HOOK_ID}' (e.g. 'check-model-name-contract') --all-files" && echo

# render the jinja template & overwrite the existing pre-commit-config file, just as part of this CICD job
j2 src/jinja_templates/pre_commit/.pre-commit-config.yaml.j2 -o .pre-commit-config.yaml

#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Step 1: Prequisite step
# Run the pre-commit hook 'dbt-docs-generate' to create the dbt manifest.json & catalog.json files
#-------------------------------------------------------------------------------------------------------------------------------------------------------
print_section_header "$DEBUG" "Step 1. Run the pre-commit hook 'dbt-docs-generate' to create the dbt manifest.json & catalog.json files"
run_pre_commit "dbt-docs-generate" && echo

#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Step 2: dbt model checks
# Run the pre-commit hook 'check-model-name-contract' to ensure that the dbt model names abides to a contract.
#-------------------------------------------------------------------------------------------------------------------------------------------------------
print_section_header "$DEBUG" "Step 2: dbt model contract checks"
# 2.1: Run the pre-commit hook 'check-model-name-contract' to ensure that the dbt model names abides to a contract.
log_message "$DEBUG_DETAILS" "# Run the pre-commit hook 'check-model-name-contract' to ensure that the dbt model names abides to a contract."
run_pre_commit "check-model-name-contract" && echo
# 2.2: Run the pre-commit hook 'check-script-ref-and-source' to ensure that dbt models only use existing refs and sources.
# log_message "$DEBUG_DETAILS" "# Run the pre-commit hook 'check-script-ref-and-source' to ensure that dbt models only use existing refs and sources."
# run_pre_commit "check-script-ref-and-source" && echo
# 2.3: Run the pre-commit hook 'check-column-name-contract' to ensure that dbt model column names abides to a contract.
# log_message "$DEBUG_DETAILS" "# Run the pre-commit hook 'check-column-name-contract' to ensure that dbt model column names abides to a contract."
# run_pre_commit "check-column-name-contract" && echo

#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Step 3: dbt macro checks
#-------------------------------------------------------------------------------------------------------------------------------------------------------
print_section_header "$DEBUG" "Step 3: dbt macro checks"
# 3.1: Run the pre-commit hook 'check-macro-has-description' to ensure all macros have a description.
log_message "$DEBUG_DETAILS" "# 3.1. Run the pre-commit hook 'check-macro-has-description' to ensure all macros have a description."
run_pre_commit "check-macro-has-description"
# 3.2: Run the pre-commit hook 'check-macro-arguments-have-desc' to ensure all macro args have a description.
log_message "$DEBUG_DETAILS" "# 3.2. Run the pre-commit hook 'check-macro-arguments-have-desc' to ensure all macros args have a description."
run_pre_commit "check-macro-arguments-have-desc" && echo

#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Step 4: Housekeeping
#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Run the pre-commit hook 'remove-script-semicolon' to remove the semicolon at the end of the script.
#-------------------------------------------------------------------------------------------------------------------------------------------------------
print_section_header "$DEBUG" "Step 4. Run the pre-commit hook 'remove-script-semicolon' to remove the semicolon at the end of the script."
run_pre_commit "remove-script-semicolon"
