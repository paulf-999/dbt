.EXPORT_ALL_VARIABLES:

export PROFILE_DIR_CMD := --profiles-dir=profiles

build:
    dbt build ${PROFILE_DIR_CMD}

clean:
    $(info [+] Target: 'clean'. Utility function that deletes all folders specified in the clean-targets list specified in dbt_project.yml.)
    dbt clean
    # You can use this to delete the `dbt_packages` and `target` directories.
    @echo
    # NOTE: CLI only
    @echo
    # Note: this command doesn't work when interfacing with the RPC server (that powers the dbt Cloud IDE), in order to avoid complex perms issues.

compile:
    dbt compile ${PROFILE_DIR_CMD}
    $(info [+] Target: 'compile'. Generates executable SQL from analysis, test and model files - ATM)
    @echo
    # NOTE: compiles models in a project from MODEL, TEST & ANALYSIS files
    # useful for visually inspecting generated SQL output

debug:
    $(info [+] Target: 'debug'. Utility function to show debug information.)
    dbt debug ${PROFILE_DIR_CMD}
    #dbt debug ${PROFILE_DIR_CMD} --config-dir
    # NOTE: CLI only
    @echo
    #The --config-dir option to dbt debug will show you where your .dbt configuration directory is located

deps:
    $(info [+] Target: 'deps'. Pulls the most recent version of the dependencies listed in your packages.yml from git.)
    dbt deps
    @echo
    # dbt will display up to date and/or latest versions of packages that are listed on dbt Hub.
    # NOTE: This does NOT apply to packages that are installed via `GIT`/`local`
    # I.e., you'll get messages like, 'up to date!'
    # See Package-Management for more information (link: https://docs.getdbt.com/docs/building-a-dbt-project/package-management)

docs:
    dbt docs generate ${PROFILE_DIR_CMD}
    #dbt docs generate --no-compile ${PROFILE_DIR_CMD}
    # has 2 supported subcommands: `generate` and `serve`.
    ####################
    # generate command #
    ####################
    # generate command is responsible for generating project doc website by:
    # 1) copying index.html into the /target dir
    # 2) compiling the project to target/manifest.json
    # 3) producing target/catalog.json (contains metadata about tables & views produced by the models in the project.)
    # Use the --no-compile argument to skip re-compilation
    # When this flag is provided, dbt docs generate will only execute steps (1) and (3), as described above.
    #################
    # serve command #
    #################
    # starts a webserver on port 8000 to serve your documentation locally. The webserver is rooted in your target/ directory.
    # You may specify a different port using the --port flag.

init:
    dbt init ${PROFILE_DIR_CMD}
    # initialise your dbt project
    # if you've just cloned or downloaded an existing dbt project, dbt init can still help you set up your connection profile so that you can start working quickl
    # dbt init knows how to prompt for connection information by looking for a file named profile_template.yml. It will look for this file in two places:
    # adapter plugin (if you're the maintainer)
    # or for an existing project, it'll look for custom profile_template.yml in the root of your project, alongside dbt_project.yml
    # For common connection attributes, set the values in fixed; leave user-specific attributes in prompts, but with custom hints and defaults as you'd like.

list:
    dbt ls ${PROFILE_DIR_CMD}
    # NOTE: CLI only
    # list resources in your dbt project
    # alias for list
    # Accepts selector arguments that are similar to those provided in dbt run
    # dbt ls \
    # [--resource-type {source,analysis,model,snapshot,test,seed,exposure,default,all}] \
    # [--select SELECTION_ARG [SELECTION_ARG ...]] \
    # [--models SELECTOR [SELECTOR ...]] \
    # [--exclude SELECTOR [SELECTOR ...]] \
    # [--selector YML_SELECTOR_NAME [YML_SELECTOR_NAME ...]] \
    # [--output {json,name,path,selector}] \
    # [--output-keys KEY_NAME [KEY_NAME]]

parse:
    dbt parse ${PROFILE_DIR_CMD}
    # parses your dbt project and writes detailed timing information. If your project contains Jinja or YAML syntax errors, the command will fail.

seed:
    dbt seed  ${PROFILE_DIR_CMD}

source:
    dbt source freshness ${PROFILE_DIR_CMD} # --select

snapshot:
    dbt snapshot ${PROFILE_DIR_CMD}

test:
    dbt test ${PROFILE_DIR_CMD}
    # --select test_type, test_type:generic/singular
    # --store-failures

rpc:
    dbt  ${PROFILE_DIR_CMD}

run:
    dbt run ${PROFILE_DIR_CMD}
    dbt run ${PROFILE_DIR_CMD} --full-refresh
    # dbt run executes compiled sql model files against the current target database
    # connects to TARGET tb & runs relevant SQL
    # Models are run in the order defined by the dependency graph generated during compilation.
    # Intelligent multi-threading is used to minimize execution time without violating dependencies.
    # NOTE: frequent model updates
    # Deploying new models frequently involves destroying prior versions of these models. In these cases, dbt run minimizes the amount of time in which a model is unavailable by first building each model with a temporary name, then dropping the existing model, then renaming the model to its correct name. The drop and rename happen within a single database transaction for database adapters that support transactions.
    ##############################
    # Refresh incremental models #
    ##############################
    # If you provide the --full-refresh argument to dbt run, dbt will treat incremental models as table models
    # Further, the is_incremental() macro will return false for all models in response when the --full-refresh flag is specified.

run_operation:
    # used to invoke a macro.
    dbt run-operation ${PROFILE_DIR_CMD}
    # e.g., dbt run-operation {macro} --args {args}
