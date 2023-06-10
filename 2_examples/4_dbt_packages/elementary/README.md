# ELementary

## Prerequisites

**1. Elementary CLI**

To install the monitor module run: `pip install elementary-data`

Run one of the following commands based on your platform (no need to run all):

`pip install 'elementary-data[snowflake]'`

Run `edr --help` in order to ensure the installation was successful.

**2. Snowflake Role Permissions**

Make sure your user has permissions to create schemas

**3. `dbt_project.yml`**

Add the following to models section of the `dbt_project.yml` file to ensure all elementary artefacts are written to the schema called 'elementary`:

```yaml
models:
  ## see docs: https://docs.elementary-data.com/
  elementary:
    ## elementary models will be created in the schema '<your_schema>_elementary'
    +schema: "elementary"
    ## To disable elementary for dev, uncomment this:
    enabled: "{{ target.name in ['prod'] }}"
```

**4. Generate a profile for Elementary**

Run the following to create a connection profile for elementary:

`dbt run-operation elementary.generate_elementary_cli_profile`

Note: Ensure that you fill in your password and any other missing fields after you paste the profile in your local `profiles.yml` file.

---

## How to use

1. Install the package by running `dbt deps`
2. Run to create the package models: `dbt run --select elementary`

This will mostly create empty tables, that will be updated with artifacts, metrics and test results in your future dbt executions.

3. Run tests, i.e., type: `dbt test`

After you ran your tests, we recommend that you ensure that the results were loaded to `elementary_test_results` table.

### What Happens Next?

Once the elementary dbt package has been installed and configured, your test results, run results and dbt artifacts will be loaded to elementary schema tables.

## Example Usage

With all of the above in place, you can now generate your test report UI by running the following command:

`edr report`

The command will use the provided connection profile to access the data warehouse, read from the Elementary tables, and generate the report as an HTML file.

And you're done! Next think about how you want to host the generated HTML.
