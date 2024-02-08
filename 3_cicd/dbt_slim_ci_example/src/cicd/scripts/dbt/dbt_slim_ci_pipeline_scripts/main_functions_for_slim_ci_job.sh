#!/bin/bash
# shellcheck disable=SC2181,SC1090

#=======================================================================
# Variables
#=======================================================================

# global dbt vars
DBT_PROJECT_DIRECTORY="prod_analytics" # DBT_PROJECT_DIR is a reserved env var used by dbt, so we need to use an alternative var name (DBT_PROJECT_DIRECTORY)
DBT_PROFILE_ARGS="--profiles-dir=profiles"
DBT_PROD_RUN_ARTIFACTS_DIR="tmp/dbt_prod_run_artifacts"

# common dbt commands
DBT_COMPILE_CMD="dbt --quiet compile ${DBT_PROFILE_ARGS}"
DBT_DEFER_STATE_MODIFIED_CMD="--defer --state=${DBT_PROD_RUN_ARTIFACTS_DIR} ${DBT_PROFILE_ARGS}"

# common git commands
SOURCE_GIT_BRANCH_NAME="origin/${1}"
TARGET_GIT_BRANCH_NAME="origin/master"

#=======================================================================
# Functions
#=======================================================================

# Read in common logging functions
source src/cicd/scripts/common/common_cicd_functions.sh

# Read in supplementary dbt functions (make the code easier to read/modularise the code)
source src/cicd/scripts/dbt/dbt_slim_ci_pipeline_scripts/supporting_dbt_cicd_functions.sh

# Generate the dbt manifest.yaml file on the MASTER branch
generate_manifest_on_master_branch() {
    log_message "${DEBUG}" "# 1.1. Checkout the MASTER branch & activate the python venv."
    log_message "${DEBUG_DETAILS}" "# Command: 'git checkout ${TARGET_GIT_BRANCH_NAME}'"
    git checkout ${TARGET_GIT_BRANCH_NAME} && echo
    # activate the venv
    source venv/bin/activate

    log_message "${DEBUG}" "# 1.2. Generate the dbt manifest.json file for the MASTER branch & store in /tmp dir. This is used for comparison later"
    log_message "${DEBUG_DETAILS}" "# Command: 'cd ${DBT_PROJECT_DIRECTORY} && ${DBT_COMPILE_CMD} --target-path=${DBT_PROD_RUN_ARTIFACTS_DIR}'"
    cd ${DBT_PROJECT_DIRECTORY} && ${DBT_COMPILE_CMD} --target-path=${DBT_PROD_RUN_ARTIFACTS_DIR} && echo

    log_message "${DEBUG}" "# 1.3. Confirm that the manifest.json file is inside ${DBT_PROD_RUN_ARTIFACTS_DIR}."
    log_message "${DEBUG_DETAILS}" "# Command: 'ls -la ${DBT_PROD_RUN_ARTIFACTS_DIR}'"
    ls -la ${DBT_PROD_RUN_ARTIFACTS_DIR} && echo
}

# Generate the dbt manifest.yaml file on the FEATURE branch
generate_manifest_on_feature_branch() {
    log_message "${DEBUG}" "# 2.1. Let's make sure we're on our FEATURE branch"
    log_message "${DEBUG_DETAILS}" "# Command: 'git checkout ${SOURCE_GIT_BRANCH_NAME}'"
    git checkout ${SOURCE_GIT_BRANCH_NAME} && echo

    log_message "${DEBUG}" "# 2.2. Generate the dbt manifest file for the FEATURE branch."
    log_message "${DEBUG_DETAILS}" "# Command: '${DBT_COMPILE_CMD}'"
    $DBT_COMPILE_CMD && echo

    log_message "${DEBUG}" "Confirm that the manifest.json file is inside the 'target' directory."
    log_message "${DEBUG_DETAILS}" "# Command: 'ls -la target'"
    ls -la target && echo
}

# Check whether there are any new/modified dbt models
orchestrate_dbt_slim_ci_job() {

    # Check for dbt seed changes
    FLAG_CHANGED_FILES=$(detect_dbt_seed_changes)

    DBT_LS_CMD=$(dbt --quiet ls --select state:modified --state=${DBT_PROD_RUN_ARTIFACTS_DIR} ${DBT_PROFILE_ARGS})
    log_message "${DEBUG_DETAILS}" "# Command: 'dbt --quiet ls --select state:modified --state=${DBT_PROD_RUN_ARTIFACTS_DIR} ${DBT_PROFILE_ARGS}'"

    echo "${DBT_LS_CMD}" > dbt_modified_models.txt # also write out the the list of new/modified dbt models to a file

    echo && log_message "${DEBUG}" "# 3.1. Check whether there are any new/modified dbt models."

    # if there are new/modified dbt models or dbt seed changes, orchestrate the main function
    if [[ -n "${DBT_LS_CMD}" || $FLAG_CHANGED_FILES ]]; then
        # New/modified dbt models or dbt seed changes found - start dbt slim CI job execution
        log_message "${DEBUG_DETAILS}" "# New/modified dbt models found!" && echo
        execute_dbt_slim_ci_job
    # otherwise, skip the dbt run & snapshot steps - no new/modified dbt models were found.
    else
        log_message "${DEBUG}" "# No new/modified dbt models were found. Skipping dbt run." && echo
    fi
}

# Execute the dbt slim CI job
execute_dbt_slim_ci_job() {
    print_section_header "$DEBUG" "Step 4: Start dbt slim CI job execution, to run only new/modified & downstream dbt models."
    log_message "$DEBUG_DETAILS" "# Listed below are the new/modified dbt models, that are to be executed as part of this job run:" && cat dbt_modified_models.txt & echo

    log_message "$DEBUG" "# 4.1. Let's first check to see if there are any dbt seed changes" && echo

    # Get the flag value from detect_dbt_seed_changes function
    FLAG_CHANGED_FILES=$(detect_dbt_seed_changes)

    if $FLAG_CHANGED_FILES; then
        log_message "${DEBUG_DETAILS}" "# New/modified dbt seed detected! Run dbt seed against the temporary cicd target."
        execute_dbt_cmd "dbt seed ${DBT_PROFILE_ARGS} --target=cicd_temp_timestamp_prefix" && echo
    fi

    log_message "$DEBUG" "# 4.2. Let's next only run the new/modified dbt models identified."
    execute_dbt_cmd "dbt run --select state:modified+ ${DBT_DEFER_STATE_MODIFIED_CMD} --target=cicd_temp_timestamp_prefix" && echo

    log_message "$DEBUG" "# 4.3. As the dbt run was successful against the temporary cicd target, let's now run it against the default dbt target."
    if $FLAG_CHANGED_FILES; then
        log_message "${DEBUG_DETAILS}" "# New/modified dbt seed detected! Run dbt seed against the default cicd target." && echo
        execute_dbt_cmd "dbt seed ${DBT_PROFILE_ARGS}" && echo
    fi
    execute_dbt_cmd "dbt run --select state:modified+ ${DBT_DEFER_STATE_MODIFIED_CMD}" && echo

    log_message "$DEBUG" "# 4.4: Now attempt to run the dbt snapshots."
    execute_dbt_cmd "dbt snapshot ${DBT_DEFER_STATE_MODIFIED_CMD}" && echo
    print_section_header "${INFO}" "Success: dbt slim CI job completed successfully." && echo
}

# Check to see if the git PR contains any dbt seed changes
detect_dbt_seed_changes() {
    # Git command to list changed files and count the number of changes
    CHANGED_FILES=$(git diff --name-only --diff-filter=ADMR "${TARGET_GIT_BRANCH_NAME}".."${SOURCE_GIT_BRANCH_NAME}" | sort -u)

    # Check if any changed file has the specified prefix
    FLAG_CHANGED_FILES=false

    for file in $CHANGED_FILES; do
        if [[ $file == "prod_analytics/data/"* ]]; then
            FLAG_CHANGED_FILES=true
            break
        fi
    done

    # Return the flag value
    echo $FLAG_CHANGED_FILES
}
