# Project structure review

Page source: https://docs.getdbt.com/guides/best-practices/how-we-structure/5-the-rest-of-the-project

```
models
├── intermediate
│   └── finance
│       ├── _int_finance__models.yml
│       └── int_payments_pivoted_to_orders.sql
├── marts
│   ├── finance
│   │   ├── _finance__models.yml
│   │   ├── orders.sql
│   │   └── payments.sql
│   └── marketing
│       ├── _marketing__models.yml
│       └── customers.sql
├── staging
│   ├── jaffle_shop
│   │   ├── _jaffle_shop__docs.md
│   │   ├── _jaffle_shop__models.yml
│   │   ├── _jaffle_shop__sources.yml
│   │   ├── base
│   │   │   ├── base_jaffle_shop__customers.sql
│   │   │   └── base_jaffle_shop__deleted_customers.sql
│   │   ├── stg_jaffle_shop__customers.sql
│   │   └── stg_jaffle_shop__orders.sql
│   └── stripe
│       ├── _stripe__models.yml
│       ├── _stripe__sources.yml
│       └── stg_stripe__payments.sql
└── utilities
    └── all_dates.sql
```

✅ Config per folder.

As in the example above, create a _[directory]__models.yml per directory in your models folder that configures all the models in that directory. for staging folders, also include a _[directory]__sources.yml per directory.
The leading underscore ensure your YAML files will be sorted to the top of every folder to make them easy to separate from your models.
YAML files don’t need unique names in the way that SQL model files do, but including the directory (instead of simply _sources.yml in each folder), means you can fuzzy find for the right file more quickly.
We’ve recommended several different naming conventions over the years, most recently calling these schema.yml files. We’ve simplified to recommend that these simply be labelled based on the YAML dictionary that they contain.
If you utilize doc blocks in your project, we recommend following the same pattern, and creating a _[directory]__docs.md markdown file per directory containing all your doc blocks for that folder of models.
