# dbt_project_evaluator (version 0.6.2)

## Prerequisites

**dbt Packages**

* `dbt_utils` package: requires version 0.9.2

**Snowflake Role Permissions**

The Snowflake role used will require (at least)

* Create Table/View permissions in the DB & Schema
* (If the schema doesn't exist) - the ability to create a schema

## How to use

1. Install the package (see `packages.yml`), by running `dbt deps`.
2. run: `dbt build --select package:dbt_project_evaluator`
