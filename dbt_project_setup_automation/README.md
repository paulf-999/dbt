# dbt Code Generation Workflow

Scripts to:

* Automate the dbt project setup process.
* Generate prerequisite (dbt) SQL and yaml files in bulk.

---

## Contents

1. How-to Run
  * Prerequisites

2. Overview
  * dbt Project Setup Automation
  * Generate the dbt 'source properties' file (`_source.yml`)
  * Generate dbt SQL objects in bulk
  * Note: Data Dictionary/Metadata Required for Features 2 and 3

---

## 1. How-to Run

1. Install the prerequisites libraries by running: `make deps`.
2. Run `make install` to:

* a. Setup a dbt project & validate source DB connectivity
* b. Generate a dbt source properties file (`source.yml`)
* c. Generate (dbt) SQL Files in bulk (i.e., snapshots or 'incremental' [loads])

### Prerequisites

Before you run the above commands, ensure you provide values for each of the keys in `ip/config.yaml`.

For a description breakdown of each of the input args, see `ip/prerequisites.md`.

In addition, for a breakdown of each of the input args used for the data dictionary field mapping args, see `ip/data_dic_field_mapping_prereqs.md`.

---

## 2. Overview

A `Makefile` has been used to orchestrate the steps required to set up a dbt project. Whereby this dbt project also bundles in commonly used dbt packages, macros and templates to ensure best practice naming/structures are followed . The orchestration steps consist of:

### 1. dbt Project Setup Automation

* See `init_dbt_project` in the `Makefile`.
* This step automates the creation of a dbt project using inputs provided in `ip/config.yaml` to populate Jinja templates (see `templates` dir), as well as:

  * Populate the `profiles.yml` and verifying source DB connectivity, using the creds you provide (from `ip/config.yaml`)

  * Bundle in the install of best-practice dbt packages, e.g.: `dbt_util`, `dbt-codegen` and `dbt_expectations` & `dbt-project-evaluator`.

  * Include additional dbt macros, e.g.: `generate_schema_name`, as well as macros used for DQ testing.

### 2. Generate the dbt 'source properties' file (`_source.yml`)

* See `gen_source_properties_file` in the `Makefile`.
* This step automates the creation of the dbt source properties file (i.e., `_source.yml`) for each data source, using the python script `py/gen_source_properties.py`.
* A key prerequisite for this step is for the user to supply data dictionary type input file, to indicate (per table) at a field-level:
  * The field description
  * and flags to indicate whether the following 'generic' dbt test should be applied to the field:
    * Unique
    * Not null
    * Accepted values
    * Relationship constraints

### 3) Generate dbt SQL objects in bulk

* See `gen_dbt_sql_objs` in the `Makefile`.
* This steps automates generatating (dbt) SQL files in bulk (either as: `snapshot` or `incremental [load]` SQL files) using Jinja templates. It does this using the python script `py/gen_dbt_sql_objs.py`.
* As with step 2 'Generate the dbt 'source properties' file', a key prerequisite for this step is for the user to supply a data-dictionary type input file (this time at the data source-level), to indicate per source table what the:
  * Primary key is
  * and what the 'last_updated_field' is per table

### Note: Data Dictionary/Metadata Required for Features 2 and 3

As mentioned, features 2 and 3 above rely on using an input data dictionary file to generate the respective output files. As such, if you don't want to make use of this, comment out the calls to the targets `gen_dbt_sql_objs` and `gen_source_properties_file` in the `Makefile`.

For more information on the fields & field mappings used for any input data dictionary, see `data_dic_field_mapping_prereqs.md`.
