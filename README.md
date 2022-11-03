# dbt Projects

## dbt Code Generation Worflow

Automation scripts to accelerate dbt development, namely using code generation scripts to:

1. Automate the dbt project setup process, designing the project to follow best practices & include common best practice files.
2. Generate (dbt) SQL files in bulk either as: `snapshots` tables or `incremental` loads.
3. Automate the creation of the dbt `_source.yml` resource property file for a given data source.
4. Recreate the [target dbt project structure recommended by dbt](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview#guide-structure-overview).

## Local dbt Setup Using 3 Musketeers

Local dbt setup using the 3 Musketeers pattern and a `Makefile` to automate the setup steps required when initially creating a DBT project.
