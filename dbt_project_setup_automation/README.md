# dbt (Project) Setup Automation

Automation script(s) for dbt, namely to script:

1) Setting up a dbt project.
2) Generating a source properties file (`source.yml`) for each data source.
3) Generating (dbt) SQL files in bulk either as: snapshots tables or incremental loads.

---

## Contents

1. High-level summary
2. Getting started
    - How-to run
    - Prerequisites
3. dbt 'code generation workflow'

---

## 1. High-level summary

A `Makefile` has been used to orchestrate the steps required to:

1) Setup a dbt project.
2) Generate a source properties file (`source.yml`) for each data source.
3) Generate (dbt) SQL files in bulk either as: snapshots tables or incremental loads.

Whereby the steps used to perform these consist of the following:

### Setup a dbt project

i. Initialising a dbt project, using the inputs provided in `ip/config.json` to populate Jinja template files (see `templates` dir).

ii. Verifying DB connectivity, using the creds you provide (from `ip/config.json`)

iii. Installing the required dbt packages (`dbt_util`, `codegen`, `dbt_expectations` & `dbt_project_evaluator`)

### Generate a Source Properties File (source.yml)

Using the python script `py/gen_source_properties.py` to generate the prerequisite dbt 'schema.yml' file, containing source details.

### Generate (dbt) SQL Files in Bulk (Snapshots or Incremental Loads)

Using the python script `py/gen_dbt_sql_objs` to generate the `snapshot` & `incremental` data model files in bulk, using an input data dictionary

---

## 2. Getting started

### How-to run

1. Install the prerequisites libraries by running: `make deps`. Doing so will install `dbt-snowflake`.
2. Run `make install` to build your dbt project and validate the connectivity.

---

## 3. dbt 'code generation workflow'

Part of the featured functionality is to generate SQL files in bulk based upon an input data dictionary file (as such, a prerequisite to this is to provide an input data dictionary file.)

This is, by nature, a little bespoke. As such, if you don't want to make use of this, comment out line 50 in the `Makefile`.
