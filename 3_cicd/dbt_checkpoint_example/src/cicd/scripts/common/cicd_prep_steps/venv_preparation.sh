#!/bin/bash

#=======================================================================
# Variables
#=======================================================================
CICD_SCRIPTS_DIR=src/cicd/scripts

PY_VENV_PKG="python3.8-venv"
VENV_INSTALL_CMD="apt update -qq && apt install $PY_VENV_PKG -qq"
PIP_VENV_INSTALL_CMD="pip install virtualenv -q"
REQUIREMENTS_TXT_FILE_PATH=${1}
PIP_INSTALL_REQS_CMD="pip install -r ${REQUIREMENTS_TXT_FILE_PATH} -q"

#=======================================================================
# Functions
#=======================================================================
# read in common logging functions
source ${CICD_SCRIPTS_DIR}/common/common_cicd_functions.sh

#=======================================================================
# Main script logic
#=======================================================================

# run common date/time execution script
source ${CICD_SCRIPTS_DIR}/common/common_date_time_scr_execution.sh

# read in the functions from a separate shell script for bbetter code readability
source ${CICD_SCRIPTS_DIR}/common/cicd_prep_steps/functions_for_venv_prep.sh

# Step 1: Check if the package is already installed
log_message "${DEBUG}# Step 1: Check if the package '$PY_VENV_PKG' is already installed."
install_package $PY_VENV_PKG "$VENV_INSTALL_CMD"

# Step 2: Check if the 'venv' virtual environment folder exists. And if a previous venv exists, deactivate it.
log_message "${DEBUG}# Step 2: Check if the 'venv' virtual environment folder exists. And if a previous venv exists, deactivate it."
if [ -d "venv" ]; then
    log_message "${DEBUG_DETAILS}'venv' virtual environment folder already exists, delete it (command: deactivate)."
    deactivate && echo
else
    log_message "${DEBUG_DETAILS}Do nothing/proceed - 'venv' virtual environment folder not found." && echo
fi

# Step 3: Troubleshooting step: List the contents of the 'prod_analytics' directory, to verify a 'venv' folder doesn't exist.
log_message "${DEBUG}# Step 3: Troubleshooting step: verify that a 'venv' virtual environment folder DOESN'T exist by listing the contents of the directory."
ls -la && echo

# Step 4: Pip install virtualenv, if it's available & not already installed
log_message "${DEBUG}# Step 4: Run '$PIP_VENV_INSTALL_CMD', if it's available & not already installed."
install_package "virtualenv" "$PIP_VENV_INSTALL_CMD"

# Step 5: Create a virtualenv called 'venv'
create_and_activate_venv

# Step 6: Verify that 'venv' virtual environment folder exists
log_message "${DEBUG}# Step 6: Verify that 'venv' virtual environment folder exists. Command: ls -la." && echo
ls -la && echo

# Step 7: Regardless of whether a virtualenv was installed correctly, install the required python libraries.
log_message "${DEBUG}# Step 7: Install the required python libraries, command: $PIP_INSTALL_REQS_CMD." && echo
eval $PIP_INSTALL_REQS_CMD

# Step 8: Verify the required python libraries were installed.
log_message "${DEBUG}# Step 8: List Python packages installed, command: pip list."
pip list && echo
