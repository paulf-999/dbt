```
<(L&V) dbt project structure - parent project name>
    |
    (dbt project files, e.g.:)
    │
    └───analysis
    └───data
    └───dbt_modules
        └─── <child dbt_project layer 1>
        └─── <child dbt_project layer 2>
        └─── <child dbt_project layer 3>
    └───macros
    └───models
    └───profiles
    └───snapshots
    └───tests
    ...
    dbt_project.yml
```