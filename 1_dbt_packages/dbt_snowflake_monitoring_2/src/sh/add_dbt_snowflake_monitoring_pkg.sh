#!/bin/bash

# Load configuration from YAML
DBT_PROJECT_DIRECTORY=$(eval echo $(yq -r '.dbt_project_dir' config.yaml))

# Function to render Jinja template and append to packages.yml
render_and_append_to_packages() {
    # Render Jinja template using j2cli
    local rendered_content=$(j2 src/jinja_templates/packages.yml.j2)

    echo "RENDERED_CONTENT = ${rendered_content}"

    # Append to packages.yml
    echo -e "\n$rendered_content" >> "${DBT_PROJECT_DIRECTORY}"/packages.yml
}

# Call the function
render_and_append_to_packages
