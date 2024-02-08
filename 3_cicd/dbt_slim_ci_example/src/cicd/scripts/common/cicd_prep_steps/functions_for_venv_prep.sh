#!/bin/bash
#=======================================================================
# Variables
#=======================================================================
ACTIVATE_VENV_CMD="python3 -m venv venv && source venv/bin/activate"

#=======================================================================
# Functions
#=======================================================================
# read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

# Function to check if a package is available in the repository
check_package_available() {
    if apt-cache show $1 2>/dev/null | grep -q "Package: $1"; then
        return 0  # Package is available
    else
        return 1  # Package is not available
    fi
}

# Function to check if a package is installed
check_package_installed() {
    dpkg -l | grep -q "$1"
}

# Function to perform package installation
install_package() {
    if ! check_package_installed $1; then
        log_message "${DEBUG_DETAILS}The package '$1' is not installed, but will be installed using the command: '$2'."
        eval $2 && echo
    else
        log_message "${DEBUG_DETAILS}The package '$1' is already installed, skipping installation." && echo
    fi
}

# Function to create and activate a virtual environment
create_and_activate_venv() {
    log_message "${DEBUG}# Step 5: Create and activate a virtual environment named 'venv'. Command: $ACTIVATE_VENV_CMD.${COLOUR_OFF}" && echo
    eval $ACTIVATE_VENV_CMD
}
