#!/bin/bash

# Source common functions
. src/sh/common.sh

# Read models from config.yaml
quick_dbt_models=$(yq -r '.dbt_models.quick_dbt_models | map(.) | join(" ")' config.yaml)
quick_dbt_models2=$(yq -r '.dbt_models.quick_dbt_models2 | map(.) | join(" ")' config.yaml)
long_running_dbt_models=$(yq -r '.dbt_models.long_running_dbt_models | map(.) | join(" ")' config.yaml)
long_running_w_dependencies=$(yq -r '.dbt_models.long_running_w_dependencies | map(.) | join(" ")' config.yaml)
long_running_w_dependencies2=$(yq -r '.dbt_models.long_running_w_dependencies2 | map(.) | join(" ")' config.yaml)

# Set up the signal handler to allow the user to hit Ctrl+C to terminate execution
trap handle_interruption INT

#=======================================================================
# Main script logic
#=======================================================================

# Prompt the user for running quick_dbt_models
read -p "Do you want to create the 'quick to execute' dbt models? (yes/y): " answer_quick
if [[ $answer_quick =~ ^[Yy](es)?$ ]]; then
    execute_dbt_models "Quick Models" "${quick_dbt_models[*]}"
    execute_dbt_models "Quick Models" "${quick_dbt_models2[*]}"
else
    print_info_message "Quick Models not executed as per user's choice."
fi

# Prompt the user for running long_running_dbt_models
echo && read -p "Do you want to run long_running_dbt_models? (yes/y): " answer_long </dev/tty
if [[ $answer_long =~ ^[Yy](es)?$ ]]; then
    execute_dbt_models "Long Running Models" "${long_running_dbt_models[*]}"
    execute_dbt_models "Long Running Models" "${long_running_w_dependencies[*]}"
    execute_dbt_models "Long Running Models" "${long_running_w_dependencies2[*]}"
else
    print_info_message "Long Running Models not executed as per user's choice."
fi

# Add any additional logic or messages as needed
print_info_message "Script execution completed."
