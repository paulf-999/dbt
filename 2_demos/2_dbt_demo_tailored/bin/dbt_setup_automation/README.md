## DBT (Project) Setup Automation

Script to automate the setup steps required when initially creating a DBT project.

---

## Contents

1. High-level summary
2. Getting started
    * Prerequisites
    * How-to run
3. Additional info
    * Custom database schemas
    * Custom data model config setting
    * Note: data model, 'models/analytics_db' is just an example
---

## 1. High-level summary

A `makefile` has been used to orchestrate the steps required to create setup a DBT project. Where these steps consist of:

1) Installing DBT using brew (if required)
2) Initialising a DBT project (`dbt_project.yml`), including steps to:
    * populating parameterized args
    * copy predefined:
        - DBT profiles (`profiles.yml`)
        - models
        - tests
        - and sources (within `schema.yml` file)
3) Setup `dbt_project.yml` file:
    * the file created in step 2 needs to be configured
    * this step automates the configuration, using templates and parameterized args
4) Validate the database connection

---

## 2. Getting started

## Prerequisites

### Makefile variables

To run the automation script, the 4 variables (below) at the top of the `Makefile` need to be assigned values. The purpose of these variables is as follows:


| Variable | Description                  | Example |
| -------| -----------------------------| --- |
| DBT_PROFILE_NAME | The name of the profile to use, containing the details required to connect to your data warehouse. Will be used to populate `profiles.yml`. | `eg_client_project_non_prod` |
| DBT_PROJECT_NAME | The name you wish to use for your DBT project. A dbt project is a directory of `.sql` and `.yml` files, which dbt uses to transform your data. | `eg_project` |
| DBT_MODEL | * Typically aligns to the name of your target database.<br/>* Models are defined in `.sql` files, typically in the `models` directory)<br/>* Note: this must be lowercase and hyphens, spaces or underscores aren't allowed for this value | `curated_db` |
| PROGRAM | * Accronym to describe the program of work<br/>* Used extensively to prefix DB/account objects<br/>* Note: hyphens, spaces or underscores aren't allowed for this value | `DFP` <br/>(accronym for 'Data Foundations Project') |

### Python packages

Some Python packages are required, but are listed within the `Makefile` deps. To install these, run: `Make deps`.

These prerequisites are:

| Package | Description                  |
| -------| -----------------------------|
| dbt | To install the DBT package itself.<br/>Note: the upgrade command is required to install the latest version of DBT. |
| gettext | Used within the `Makefile` target 'setup_dbt_project_file', to perform a `sed` find and replace command |
| gnu-sed | Similar to the above, this is used within the `Makefile` target 'setup_dbt_project_file', to perform a `sed` find and replace command |

### How-to run

The steps involved in building and executing involve:

1) Populate the 4 variables at the top of the Makefile, i.e.:
    * `DBT_PROFILE_NAME`
    * `DBT_PROJECT_NAME`
    * `PROGRAM`
    * and `DBT_MODEL`
2) and run `make`!

---

## 3. Additional info

### Custom database schemas and the `generate_schema_name` macro

As documented [here](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/using-custom-schemas), all dbt models are by default built in the schema specified in your target (i.e. within your `dbt_profile.yml` file).

In my opinion this is very inflexible, as there will very often be occasions where you'll look to write your data model objects to a different target schema, which doesn't follow the default DBT behaviour.

As such, to target a custom data model schema, DBT requires the user to override the `dbt macro`, `generate_schema_name`. To do so, you need to create a SQL file within the `macros` folder.

This automation script handles this step, creating `macros\generate_schema_name.sql` for you and copying it into your DBT project.

### Custom model configuration within `dbt_project.yml`

Following on from providing functionality to target a different database schema (or a different database entirely), you then need to tell DBT what schema name to target.

This is done by specifying your model configurations. As a single source of truth, this is often done in the `dbt_project.yml` file.

#### Example custom model configuration: `eg_dbt_project_w_custom_config.yml`

An example `dbt_project.yml` file containing custom model configurations is provided as `eg_dbt_project_w_custom_config.yml`.

### Note: data model, 'models/analytics_db' is just an example

* The sql files within `models/analytics_db` are just examples, to indicate the typical contents of such files
