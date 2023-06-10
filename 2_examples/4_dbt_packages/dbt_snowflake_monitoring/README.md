# dbt_snowflake_monitoring

## Prerequisites

**1. Snowflake Role Permissions**

Grant dbt's role access to the snowflake database:

`GRANT imported privileges on database snowflake TO ROLE <your_dbt_role_name>;`

**2. `dbt_project.yml`**

Part 1 - Enable Query Tags

1. First, make sure to remove any existing `+query_tag: dbt`
2. Then add the following to your `dbt_project.yml` file:

```yaml
dispatch:
  - macro_namespace: dbt
    search_order:
      - <YOUR_PROJECT_NAME>
      - dbt_snowflake_monitoring
      - dbt
```

Part 2 - Enable Query Comments

To configure the query comments, add the following config to `dbt_project.yml`:

```yaml
query-comment:
  comment: '{{ dbt_snowflake_monitoring.get_query_comment(node) }}'
  append: true # Snowflake removes prefixed comments.
```

## Example Usage

1. Set default DB & Schema

```sql
use database [dbt-snowflake-monitoring model database];
use schema [dbt-snowflake-monitoring model schema];
```

2. Reuse the sample queries provided (see https://select.dev/docs/dbt-snowflake-monitoring/example-usage)

