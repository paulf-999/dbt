#!/bin/bash

# Read models and project directory from config.yaml
dbt_project_directory=$(eval echo $(yq -r '.dbt_project_dir' config.yaml))
dbt_profile=$(eval echo $(yq -r '.dbt_profile' config.yaml))


# ANSI escape codes for color formatting
DEBUG='\033[0;36m'    # cyan (for debug messages)
INFO='\033[0;32m'     # green (for informational messages)
WARNING='\033[0;33m'  # yellow (for warning messages)
ERROR='\033[0;31m'    # red (for error messages)
CRITICAL='\033[1;31m' # bold red (for critical errors)
COLOUR_OFF='\033[0m'   # reset text color

print_info_message() {
    local message="$1"
    echo && echo -e "${INFO}# $message"
}

execute_dbt_models() {
    local step_name="$1"
    local models_var="$2"
    eval "local models=($models_var)"

    print_info_message "$step_name - Script execution started." && echo

    # Loop through the list of models and execute dbt run in the background
    for model in "${models[@]}"; do
        (
            echo -e "${DEBUG}Executing dbt run -s ${model} --project-dir ${dbt_project_directory} --profile ${dbt_profile}${COLOUR_OFF}"

            # Check if the model is in long_running_dbt_models and print a note
            if [[ " ${long_running_dbt_models[@]} " =~ " ${model} " ]]; then
                echo -e "${WARNING}Note: The execution of this model typically takes at least 15 minutes.${COLOUR_OFF}"
            fi

            dbt run -s "$model" --project-dir "$dbt_project_directory" --profile "$dbt_profile"
        ) &
    done

    # Wait for all background processes to finish
    wait
}

# Signal handler to catch interruptions (Ctrl+C)
handle_interruption() {
    print_info_message "Script execution aborted by the user."
    exit 1
}
