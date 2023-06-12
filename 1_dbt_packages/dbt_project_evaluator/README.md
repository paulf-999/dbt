# dbt_project_evaluator (version 0.6.2)

## Contents

1. Prerequisites
2. How to use
3. Example Usage

---

Note: Look to make use of version >=0.6.0. Previous versions had poor documentation, compared to the docs found for version >=0.5 (e.g., https://dbt-labs.github.io/dbt-project-evaluator/0.6/rules/modeling/)

## 1. Prerequisites

**dbt Packages**

* `dbt_utils` package: requires version 1.0.0

**Snowflake Role Permissions**

The Snowflake role used will require (at least)

* Create Table/View permissions in the DB & Schema
* (If the schema doesn't exist) - the ability to create a schema

---

## 2. How to use

1. Install the package (see `packages.yml`), by running `dbt deps`.
2. run: `dbt build --select package:dbt_project_evaluator`

---

## 3. Example Usage

As a reference point see: https://dbt-labs.github.io/dbt-project-evaluator/0.6/rules/modeling/

However, I recommend looking at the output of the dbt tests that are running following `dbt build --select package:dbt_project_evaluator`
