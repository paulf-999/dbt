# dbt_github_actions_demo

Demo of using DBT tests as a basis for CI/CD, where GitHub actions have been used as the CI/CD technology.

---

## Contents

1. High-level summary
2. Getting started
    * Prerequisites
    * Installation
    * How-to run

---

## 1. High-level summary

This demo makes use of DBT tests as a basis for integration testing for CI/CD, where GitHub actions have been used as the CI/CD technology.

To see the logic of the CI/CD activities, see: `.github/workflows/dbt.yml`. Where at a high-level, the following is happening:

* A series of DBT tests are run, to ensure the base tables within the curated db don't contain 0 row counts. This is done using the command:
`dbt test --data --profiles-dir profiles --models ${DBT_CURATED_MODEL}`
* If these tests are successful, then the presentation layer table (within the `analytics_db` model) is created, using the following command:
`dbt run --profiles-dir profiles --models ${DBT_ANALYTICS_MODEL}`

This GitHub action could be customised further, e.g. to only be triggered by changes to certain file extensions (see [GitHub event triggers](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)). However for demo purposes, this DBT test is run each time code is pushd to the Git repo.

##### Technologies used
* GitHub actions for CI / CD
* DBT for integrating CI unit testing

##### Note

The GitHub actions make use of GitHub secrets (mentioned below).

---

## 2. Getting started

### Prerequisites

To make use of the example unit tests used for GitHub actions integration testing, the following Git secrets must be created against the repo:

* `SNOWFLAKE_ACCOUNT`
* `SNOWFLAKE_USER`
* `SNOWFLAKE_PASS`
* `SNOWFLAKE_ROLE`

## For reference:

* For an example of how to use GitHub actions to run DBT, see: https://gist.github.com/troyharvey/d61ebe704395c925bf9448183e99af3e
* For an overview of GitHub secrets (for GitHub actions), see: https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository
