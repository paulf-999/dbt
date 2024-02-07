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

1. Resolve the prerequisites mentioned in section 2.
2. Update config.yaml, specifically:
    * `dbt_project_dir`
    * and `dbt_profile`
3. Run `make deps` to install the dbt package.
4. Run `make install` to run the associated dbt models.
