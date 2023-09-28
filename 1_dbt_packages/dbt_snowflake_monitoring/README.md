# dbt_snowflake_monitoring

## Contents

1. Background
2. Prerequisites
3. Setup
4. Example Usage

---

## 1. Background

See [dbt_snowflake_monitoring](https://select.dev/docs/dbt-snowflake-monitoring).

---

## 2. Prerequisites

|   | Related to                 | Prerequisite Description                                        | Steps |
| - | -------------------------- | ------------------------------------------------------------------------------- | ----- |
| 1 | Snowflake Role Permissions | Grant dbt's role access to the snowflake database. | Run the command:<br/><br/>`GRANT imported privileges on database snowflake TO ROLE <your_dbt_role_name>;` |
| 2 | `dbt_project.yml`          | Enable Query Tags              | 1. First, make sure to remove any existing `+query_tag: dbt`<br/><br/>2. Then add the config described below underneath the heading 'Code: Enable Query Tags' to your `dbt_project.yml` file. |
| 3 | `dbt_project.yml`          | Enable Query Comments          | To configure the query comments, add the config described below underneath the heading 'Code: Enable Query Comments' to your `dbt_project.yml` file. |
| 4 | `profiles.yml`          | Create dbt Profile to target a given database/schema for your cost monitoring artefacts          | <TODO> |

**Config: Enable Query Tags**

Add the following to your `dbt_project.yml` file:

```yaml
dispatch:
  - macro_namespace: dbt
    search_order:
      - dbt_snowflake_monitoring
      - dbt
```

**Config: Enable Query Comments**

To configure the query comments, add the following config to `dbt_project.yml`:

```yaml
query-comment:
  comment: '{{ dbt_snowflake_monitoring.get_query_comment(node) }}'
  append: true # Snowflake removes prefixed comments.
```

---

## 3. Setup

1. Install the package by running `dbt deps`.
2. Alter two of the 'out of the box' queries, to only return the last month of data

Inside the dbt package files (see dbt_packages/dbt_snowflake_monitoring), to keep costs down, I recommend altering two of the out of the box queries:

* `sql_query_history`
* and `stg_access_history`

So that the above two queries instead only queries the Snowflake `ACCOUNT_USAGE` schema for the previous month of data.

See the sql files within this directory for examples of what's needed.

3. Run the models inside of the package by running the following inside a terminal:

`dbt build --select package:dbt_snowflake_monitoring`.

E.g.: `dbt build --select package:dbt_snowflake_monitoring`

Note: to write the output to a different database, run:

`dbt build --select package:dbt_snowflake_monitoring --target=<target>`

E.g.

`dbt build --select package:dbt_snowflake_monitoring --target=operations`

---

## 4. Example Usage

1. Set the default DB & Schema

```sql
use database [dbt-snowflake-monitoring model database];
use schema [dbt-snowflake-monitoring model schema];
```

2. Reuse the sample queries provided (see https://select.dev/docs/dbt-snowflake-monitoring/example-usage)
