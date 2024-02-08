#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# Read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

#=======================================================================
# Functions
#=======================================================================
validate_input_args() {
    if [ $# -eq 0 ]; then
        log_message "$ERROR" "ERROR: Missing an input arg."
        log_message "$ERROR" "Expected a single input argument."
        log_message "$ERROR" "Example: ${0} feature/change"
        exit 1
    fi
}

log_dbt_error() {
    local ERROR_MESSAGE="$1"
    local EXIT_CODE="$2"
    print_section_header "$ERROR" "ERROR: $ERROR_MESSAGE with exit code $EXIT_CODE"
    log_message "${ERROR}# See the above output and the generated logs for more information."
    log_message "${ERROR}# For information on dbt exit codes, see: https://docs.getdbt.com/reference/exit-codes". && echo
}

execute_dbt_cmd() {
    local COMMAND="$1"
    log_message "$DEBUG_DETAILS" "# Command: '${COMMAND}'" && echo
    ${COMMAND}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        log_dbt_error "dbt command failed" $EXIT_CODE
        exit 1
    fi
}
