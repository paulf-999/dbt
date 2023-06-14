# 0-copy DB clone

## Contents

1. Prerequisites
2. How to use
3. Example Usage

---

## 1. Prerequisites

TBC, re: Snowflake role permissions.

---

## 2. How to use

1. Install the package (see `packages.yml`), by running `dbt deps`.
2. run either of the following:

```bash
dbt run-operation clone_database \
  --args "{'source_database': 'production_clone', 'destination_database': 'developer_clone'}"

# set the new_owner_role
dbt run-operation clone_database \
  --args "{'source_database': 'production_clone', 'destination_database': 'developer_clone', 'new_owner_role': 'developer_role'}"
```

---

## 3. Example Usage

As a reference point see: https://github.com/Montreal-Analytics/dbt-snowflake-utils/tree/0.5.0/#snowflake_utilsclone_database-source
