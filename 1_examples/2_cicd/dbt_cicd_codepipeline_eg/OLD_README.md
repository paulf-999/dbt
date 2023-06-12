## dbt_cicd_codepipeline_eg

Files used as part of a demonstration of using DBT tests as a basis CI / CD.

| Folder                    | Description                                                                                       |
| --------------------------| --------------------------------------------------------------------------------------------------|
| bin            | Contains the DBT files (to be used as a basis for CI / CD) |
| cfn            | Contains CloudFormation template files |


### Prerequisites

* Prior to using AWS CodeBuild (used for CI / CD), you will need to create an OATH token with Git. See: https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

### Tools used

* AWS CodeBuild, CodePipeline and SSM for CI / CD
* DBT for integrating CI unit testing

### Setup

#### 1. CI / CD setup, using AWS CodePipeline

To first create a CI / CD pipeline using AWS CodeBuild, run the `Makefile` at the project root. This is just creating a CloudFormation stack, to create the CodeBuild project

#### 2. DBT setup

* The files used by DBT are within the `bin/` folder, at the project root
* Within `bin/` are is the same file / folder structure I used for my other Git repo, [DBT Setup Automation](https://github.com/paulf-999/dbt_setup_automation)
* So to create a DBT project using these files, navigate to the `bin/` folder at the project root, then do the following:

1. Populate the 4 variables at the top of the script, i.e.:

    * `DBT_PROFILE_NAME`
    * `DBT_PROJECT_NAME`
    * `PROGRAM`
    * and `DBT_MODEL`

2. Create any data model files you wish, underneath the folder `models` (also edit the `schema.yml` file).
3. Similarly, create any desired unit tests within the `tests/` folder.

Following this, run `make`!

Then to test your data model, run `make data_test_model`

#### Note

Within the `bin/` folder, ignore the `bikestores` folder - this is temporary, whilst still in dev
