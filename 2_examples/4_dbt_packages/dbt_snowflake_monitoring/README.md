# dbt_snowflake_monitoring

## Contents

1. Prerequisites
2. Example Usage

---

## 1. Prerequisites

| Folder | Description                  |
| -------| -----------------------------|
| folder | Contains files related to... |
| folder | Contains files related to... |

|   | Related to                 | Prerequisite Description                                        | Steps |
| - | -------------------------- | ------------------------------------------------------------------------------- | ----- |
| 1 | Snowflake Role Permissions | Grant dbt's role access to the snowflake database. | Run the command:<br/><br/>`GRANT imported privileges on database snowflake TO ROLE <your_dbt_role_name>;` |
| 2 | `dbt_project.yml`          | Enable Query Tags              | 1. First, make sure to remove any existing `+query_tag: dbt`<br/><br/>2. Then add the config described below underneath the heading 'Code: Enable Query Tags' to your `dbt_project.yml` file. |
| 3 | `dbt_project.yml`          | Enable Query Comments          | To configure the query comments, add the config described below underneath the heading 'Code: Enable Query Comments' to your `dbt_project.yml` file. |

**Config: Enable Query Tags**

Add the following to your `dbt_project.yml` file:

```yaml
dispatch:
  - macro_namespace: dbt
    search_order:
      - <YOUR_PROJECT_NAME>
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

## 2. Example Usage

1. Set the default DB & Schema

```sql
use database [dbt-snowflake-monitoring model database];
use schema [dbt-snowflake-monitoring model schema];
```

2. Reuse the sample queries provided (see https://select.dev/docs/dbt-snowflake-monitoring/example-usage)
