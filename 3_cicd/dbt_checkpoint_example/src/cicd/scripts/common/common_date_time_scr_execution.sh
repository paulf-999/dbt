#!/bin/bash

# Read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

echo && echo -e "${DEBUG_DETAILS}#----------------------------------------------------------"
echo -e "${DEBUG_DETAILS}# Date/time of execution"
echo -e "${DEBUG_DETAILS}#----------------------------------------------------------"
echo -e "${DEBUG_DETAILS}# Date: $(date +"%a %d %B %Y")"
echo -e "${DEBUG_DETAILS}# Time: $(date +"%H:%M %p")"
echo -e "${DEBUG_DETAILS}#----------------------------------------------------------" && echo
