#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

#=======================================================================
# Main script logic
#=======================================================================

# Include script to output date/time of script execution
source src/cicd/scripts/common/common_date_time_scr_execution.sh

# Generate a datetime timestamp variable
log_message "${DEBUG}# Step 1: Generate a datetime timestamp variable."
log_message "${DEBUG_DETAILS}This timestamp is used in the dbt profile render step." && echo

# Generate the timestamp in the format YYYYMMDD_HHMMSS
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create the variable DATETIME_TS & assign it the TIMESTAMP value for later use in the pipeline
echo "##vso[task.setvariable variable=DATETIME_TS;]$TIMESTAMP"
