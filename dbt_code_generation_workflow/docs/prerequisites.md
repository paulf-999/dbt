# Prerequisites

Though before you do run the above commands, ensure you provide values to the each of the keys in `ip/config.json`:

| Section | Parameter | Description                  | Example |
| ------- | -------| -----------------------------| --- |
| GeneralParameters | Env | The name of the environment | `DEV` |
| GeneralParameters | DbtVersion | The DBT version you want to use. I recommend using (at least) v1.2, as the project_evaluator package requires upwards of this version | `1.2.0` |
| GeneralParameters | DataDictionaryName | The name (and relative filepath) to your data dictionary | `ip/data_dictionary.csv` |
| SnowflakeParameters | SnowflakeAccount | The Snowflake account name. | `companyabc.ap-southeast-2` |
| SnowflakeParameters | SnowflakeUsername | Update this to reflect your own Snowflake username. | `jbloggs` |
| SnowflakeParameters | SnowflakePrivateKey | Generate a private key called `snowflake-rsa-key.p8` and store this within your `~/.ssh` folder. | `my-rsa-key.p8` |
| DbtParameters | DbtProfileName | The name of the profile to use, containing the details required to connect to your data warehouse. Will be used to populate `profiles.yml`.<br/> As per dbt's documentation, it's recommended to use your org name as snake_case as your profile name | `eg_company` |
| DbtParameters | DbtProjectName | The name you wish to use for your DBT project. A dbt project is a directory of `.sql` and `.yml` files, which dbt uses to transform your data. | `eg_project` |
| DbtParameters | DbtModel | * Typically aligns to the name of your target database.<br/>* Models are defined in `.sql` files, typically in the `models` directory)<br/>* Note: this must be lowercase and hyphens, spaces or underscores aren't allowed for this value | `curated_db` |
| DbtParameters | Program | * Accronym to describe the program of work<br/>* Used extensively to prefix DB/account objects<br/>* Note: hyphens, spaces or underscores aren't allowed for this value | `DFP` <br/>(accronym for 'Data Foundations Project') |
