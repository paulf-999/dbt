analysis:
    # Any .sql files found in the analyses/ directory of a dbt project will be compiled, but NOT executed
    # means that analysts can use dbt functionality like {{ ref(...) }} to select from models

actions:
    * review model selection syntax
    * review GLOBAL CONFIGS: https://docs.getdbt.com/reference/global-configs#failing-fast
    * come back to build (that will try and build the entire project)

model_selection_syntax:
    TODO
