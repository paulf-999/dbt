Re: `not_null` test

I think the `not_null` override - looks like this issue was resolved here: https://github.com/dbt-labs/dbt-core/blob/main/core/dbt/include/global_project/macros/generic_test_sql/not_null.sql

Re: `unique` test

Happy to use the override, but the justification is described in this git issue: https://github.com/dbt-labs/dbt-core/issues/5441

"My understanding has long been that modern data warehouses / query optimizers are smart enough to see the count aggregate and avoid scanning all underlying data; and that count(*) and count(1) are functionally identical. Is that a faulty assumption for your data warehouse? We're always interested in seeing benchmarks / performance measurements, or finding out if there's something we're missing!"
