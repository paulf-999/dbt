# dbt Projects

## dbt Code Generation Worflow

Automation scripts for dbt, namely to script:

1) Setting up a dbt project and validate source DB connectivity.
2) Generating a dbt resource properties file (`_source.yml`) using data from an input data dictionaries/metadata.
3) Generating the `models` file/folder structure to follow [dbt's recommend project structure](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview).
4) Generating (dbt) SQL files in bulk either as: snapshots tables or incremental loads.

## Local dbt Setup Using 3 Musketeers

Local dbt setup using the 3 Musketeers pattern and a `Makefile` to automate the setup steps required when initially creating a DBT project.
