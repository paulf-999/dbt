#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# Create colour formatting vars (using ANSI escape codes) for log messaging
DEBUG='\033[0;36m' # cyan (for debug messages)
DEBUG_DETAILS='\033[0;35m' # purple (for lower-level debugging messages)
INFO='\033[0;32m' # green (for informational messages)
WARNING='\033[0;33m' # yellow (for warning messages)
ERROR='\033[0;31m' # red (for error messages)
CRITICAL='\033[1;31m' # bold red (for critical errors)
COLOUR_OFF='\033[0m' # Text Reset

#=======================================================================
# Functions
#=======================================================================
log_message() {
    local LOG_LEVEL="$1"
    local MESSAGE="$2"
    echo -e "${LOG_LEVEL}${MESSAGE}${COLOUR_OFF}"
}

print_section_header() {
    local LOG_LEVEL="$1"
    local HEADER="$2"
    echo -e "${LOG_LEVEL}#--------------------------------------------------------------------------------------------"
    log_message "${LOG_LEVEL}# ${HEADER}"
    echo -e "${LOG_LEVEL}#--------------------------------------------------------------------------------------------${COLOUR_OFF}"
}
