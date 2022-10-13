# dbt Projects

## dbt Code Generation Worflow

Automation script(s) for dbt, namely to script:

1) Setting up a dbt project.
2) Generating source properties files (`source.yml`) from input data dictionaries/metadata.
3) Generating (dbt) SQL files in bulk either as: snapshots tables or incremental loads.

## Local dbt Setup Using 3 Musketeers

Local dbt setup using the 3 Musketeers pattern and a `Makefile` to automate the setup steps required when initially creating a DBT project.
