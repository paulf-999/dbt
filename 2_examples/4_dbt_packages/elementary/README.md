# dbt Package: [Elementary](https://www.elementary-data.com/)

## Contents

1. Prerequisites
2. How to use
3. Example Usage

---

## 1. Prerequisites

|   | Prerequisite               | Description                                                      | Steps |
| - | -------------------------- | ---------------------------------------------------------------- | ----- |
| 1 | Elementary CLI             | This is required to generate the Elementary test report          | 1. Install the monitor module by running the command:<br/> `pip install elementary-data`<br/> 2. Install the platform-specific module:<br/>`pip install 'elementary-data[snowflake]'`.<br/>3. Run `edr --help` to verify whether the installation was successful. |
| 2 | Snowflake Role Permissions | Ensure the Snowflake role used has permission to create schemas. | `GRANT CREATE SCHEMA ON DATABASE <DB>` |
| 3 | `dbt_project.yml`          | Add the following to models section of the `dbt_project.yml` file to ensure all elementary artefacts are written to the schema called 'elementary' | See below |
| 4 | Generate a profile for Elementary          | Add the following to models section of the `dbt_project.yml` file to ensure all elementary artefacts are written to the schema called 'elementary' | Run the following to create a connection profile for elementary:<br/><br/>`dbt run-operation elementary.generate_elementary_cli_profile`<br/><br/>**Note:** Ensure that you fill in your password and any other missing fields after you paste the profile in your local `profiles.yml` file. |

**Code for prerequisite 3: `dbt_project.yml`**

```yaml
models:
  ## see docs: https://docs.elementary-data.com/
  elementary:
    ## elementary models will be created in the schema '<your_schema>_elementary'
    +schema: "elementary"
    ## To disable elementary for dev, uncomment this:
    enabled: "{{ target.name in ['prod'] }}"
```

---

## 2. How to use

1. Install the package by running `dbt deps`
2. Run to create the package models: `dbt run --select elementary`

This will mostly create empty tables, that will be updated with artifacts, metrics and test results in your future dbt executions.

3. Run tests, i.e., type: `dbt test`

After you ran your tests, we recommend that you ensure that the results were loaded to `elementary_test_results` table.

### What Happens Next?

Once the elementary dbt package has been installed and configured, your test results, run results and dbt artifacts will be loaded to elementary schema tables.

---

## 3. Example Usage

With all of the above in place, you can now generate your test report UI by running the following command:

`edr report`

The command will use the provided connection profile to access the data warehouse, read from the Elementary tables, and generate the report as an HTML file.

And you're done! Next think about how you want to host the generated HTML.
