## DBT (Project) Setup Automation

Script to automate the setup steps required when initially creating a DBT project.

Whereby the DBT project is intended to generate all of the required files for a single, new data source.

---

## Contents

1. High-level summary
2. Getting started
    * How-to run
    * Prerequisites
3. DBT 'code generation workflow'


---

## 1. High-level summary

A `Makefile` has been used to orchestrate the steps required to create setup a DBT project. Where these steps consist of:

1) Initialising a DBT project, using the inputs provided in `ip/config.json` to populate Jinja template files (see `templates` dir)
2) Verifying DB connectivity, using the creds you provide (from `ip/config.json`)
3) Installing the required DBT packages (`dbt_util`, `codegen`, `dbt_expectations` & `dbt_project_evaluator`)
4) Generating the DBT `schema.yml` file using the `codegen` DBT package (point 3)
5) Using the python script `py/gen_dbt_sql_objs` to generate the `snapshot` & `incremental` data model files in bulk, using an input data dictionary
6) (In progress)Using the python script `py/gen_resource_properties.py` to generate the prerequisite DBT 'schema.yml' file, containing source details.

---

## 2. Getting started

### How-to run

1. Install the prerequisites libraries by running: `make deps`. Doing so will install `dbt-snowflake`.
2. Run `make install` to build your dbt project and validate the connectivity.


### Prerequisites

Though before you do run the above commands, ensure you provide values to the each of the keys in `ip/config.json`:

| Section | Parameter | Description                  | Example |
| ------- | -------| -----------------------------| --- |
| GeneralParameters | Env | The name of the environment | `DEV` |
| GeneralParameters | DbtVersion | The DBT version you want to use. I recommend using (at least) v1.2, as the project_evaluator package requires upwards of this version | `1.2.0` |
| GeneralParameters | DataDictionaryName | The name (and relative filepath) to your data dictionary | `ip/data_dictionary.csv` |
| SnowflakeParameters | SnowflakeAccount | The Snowflake account name. | `companyabc.ap-southeast-2` |
| SnowflakeParameters | SnowflakeUsername | Update this to reflect your own Snowflake username. | `jbloggs` |
| SnowflakeParameters | SnowflakePrivateKey | Generate a private key called `snowflake-rsa-key.p8` and store this within your `~/.ssh` folder. | `my-rsa-key.p8` |
| DbtParameters | DbtProfileName | The name of the profile to use, containing the details required to connect to your data warehouse. Will be used to populate `profiles.yml`.<br/> As per dbt's documentation, it's recommended to use your org name as snake_case as your profile name | `eg_company` |
| DbtParameters | DbtProjectName | The name you wish to use for your DBT project. A dbt project is a directory of `.sql` and `.yml` files, which dbt uses to transform your data. | `eg_project` |
| DbtParameters | DbtModel | * Typically aligns to the name of your target database.<br/>* Models are defined in `.sql` files, typically in the `models` directory)<br/>* Note: this must be lowercase and hyphens, spaces or underscores aren't allowed for this value | `curated_db` |
| DbtParameters | Program | * Accronym to describe the program of work<br/>* Used extensively to prefix DB/account objects<br/>* Note: hyphens, spaces or underscores aren't allowed for this value | `DFP` <br/>(accronym for 'Data Foundations Project') |

---


## 3. DBT 'code generation workflow'

Part of the featured functionality is to generate SQL files in bulk based upon an input data dictionary file (as such, a prerequisite to this is to provide an input data dictionary file.)

This is, by nature, a little bespoke. As such, if you don't want to make use of this, comment out line 50 in the `Makefile`.
