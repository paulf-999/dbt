#!/bin/bash

# Load configuration from YAML
DBT_PROJECT_DIRECTORY=$(eval echo $(yq -r '.dbt_project_dir' config.yaml))

# Define paths
JINJA_TEMPLATES_PATH="src/jinja_templates/sql"
DBT_TARGET_DIR="$DBT_PROJECT_DIRECTORY/dbt_packages/dbt_snowflake_monitoring/models/staging"

# Function to generate dbt model
generate_dbt_model() {
    local template_file="$1"

    # TODO - remove 'aaa_'
    j2 "$JINJA_TEMPLATES_PATH/$template_file.sql.j2" -o "$DBT_TARGET_DIR/$template_file.sql"
    echo "Generated $template_file"
}

# Generate dbt models
generate_dbt_model "stg_access_history"
generate_dbt_model "stg_query_history"
generate_dbt_model "query_base_object_access"
generate_dbt_model "query_history_enriched"
generate_dbt_model "query_base_table_access"

echo "All dbt models generated successfully."
