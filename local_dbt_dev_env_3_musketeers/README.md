# Local DBT Setup Using 3 Musketeers

Local dbt setup using the 3 Musketeers pattern and a `Makefile` to automate the setup steps required when initially creating a DBT project.

Whereby the DBT project is intended to generate all of the required files for a single, new data source.

---

## Contents

1. High-level summary
2. Getting started
    * Prerequisites
    * How-to run
3. Technologies used
    * Three Musketeers overview

---

## 1. High-level summary

A `Makefile` has been used to orchestrate the steps required to create setup a DBT project. Where these steps consist of:

1) Initialising a DBT project, using the inputs provided in `ip/config.json` to populate Jinja template files (see `templates` dir)
2) Verifying DB connectivity, using the creds you provide (from `ip/config.json`)
3) Installing the required DBT packages (`dbt_util` & `codegen`)
4) Generating the DBT `schema.yml` file, using the `codegen` DBT package (point 3)
5) Using the python script `src/gen_dbt_src_model` to generate the 'raw' DBT data model

---

## 2. Getting started

### Prerequisites

Before you begin do the following, ensure you provide values to the each of the keys in `ip/config.json` before proceeding:

| Section | Parameter | Description                  | Example |
| ------- | -------| -----------------------------| --- |
| SnowflakeParameters | SnowflakeUsername | Update this to reflect your own Snowflake username. | `jbloggs@email.com` |
| SnowflakeParameters | SnowflakePrivateKey | Generate a private key called `snowflake-rsa-key.p8` and store this within your `~/.ssh` folder. |
| DbtParameters | DbtProfileName | The name of the profile to use, containing the details required to connect to your data warehouse. Will be used to populate `profiles.yml`. | `eg_client_project_non_prod` |
| DbtParameters | DbtProjectName | The name you wish to use for your DBT project. A dbt project is a directory of `.sql` and `.yml` files, which dbt uses to transform your data. | `eg_project` |
| DbtParameters | DbtModel | * Typically aligns to the name of your target database.<br/>* Models are defined in `.sql` files, typically in the `models` directory)<br/>* Note: this must be lowercase and hyphens, spaces or underscores aren't allowed for this value | `curated_db` |
| DbtParameters | Program | * Accronym to describe the program of work<br/>* Used extensively to prefix DB/account objects<br/>* Note: hyphens, spaces or underscores aren't allowed for this value | `DFP` <br/>(accronym for 'Data Foundations Project') |
| GeneralParameters | Env | The name of the environment | `DEV` |

### How-to run

1. Install the prerequisites libraries by running: `make deps`. Doing so will install:

* `Make`
* `Docker`

2. Run `make install` to build your dbt project and validate the connectivity.

---

## 3. Technologies used

### Three Musketeers overview

For an overview of 3 Musketeers, see `docs/3_musketeers.md`.

Though to get a general understanding of the setup and processing logic, check out the `Makefile`.
