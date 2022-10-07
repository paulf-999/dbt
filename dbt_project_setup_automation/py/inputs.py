#!/usr/bin/env python3
"""
Python Version  : 3.8
* Name          : gen_resource_properties_file.py
* Description   : Parses a data dictionary file to generate a dbt source.yml file
* Created       : 15-06-2022
* Usage         : python3 dbt_schema_generator.py
"""

__author__ = "Paul Fry"
__version__ = "0.1"

import os
import logging
import yaml

# Set up a specific logger with our desired output level
logging.basicConfig(format="%(message)s")
logger = logging.getLogger("application_logger")
logger.setLevel(logging.INFO)

working_dir = os.getcwd()


def read_ip_config_file():
    """Read input from config file"""
    with open(os.path.join(working_dir, "ip", "config.yaml")) as ip_yml:
        data = yaml.safe_load(ip_yml)

    return data


def read_ip_field_mapping_data():
    """Read input from field mapping config file"""
    with open(os.path.join(working_dir, "ip", "data_dic_field_mapping_config.yaml")) as ip_yml:
        field_mapping_data = yaml.safe_load(ip_yml)

    return field_mapping_data


######################################################################################################
# Functions for gen_dbt_sql_objs.py
######################################################################################################
def get_ips_for_gen_sql_objs():
    """Read input from config file. Returns shared input args used throughout the script."""

    data = read_ip_config_file()
    env = data["general_params"]["env"]
    ip_data_src = data["general_params"]["data_src"]

    # data_src table specific key/values
    data_src_ip_tbls = {}
    data_src_ip_tbls["data_src_a"] = data["general_params"]["data_src_tables"]["data_src_a_tbls"]

    return env, ip_data_src, data_src_ip_tbls


def get_ips_for_table_level_metadata():
    data = read_ip_config_file()

    table_level_metadata = data["ip_metadata_file_params"]["table_level_metadata"]
    metadata_sheet_name = data["ip_metadata_file_params"]["metadata_sheet_name"]

    return table_level_metadata, metadata_sheet_name


######################################################################################################
# Functions for gen_source_properties.py
######################################################################################################
def get_ips_for_src_properties():
    """Read input from config file. Returns shared input args used throughout the script."""
    data = read_ip_config_file()

    field_mapping_data = read_ip_field_mapping_data()

    env = data["general_params"]["env"]
    data_src = data["general_params"]["data_src"]
    src_db_schema = data["db_connection_params"]["snowflake_src_db_schema"]

    # data dictionary inputs
    data_dictionary = field_mapping_data["data_dictionary"]
    target_op_src_filename = field_mapping_data["target_op_src_filename"].replace("{data_src}", data_src)
    data_src_tables = data["general_params"]["data_src_tables"]

    # the loop below just helps ensure the script is generic, regardless of the data_src
    xls_sheet_names = []

    for src, ip_tbls in data_src_tables.items():
        for tbl in ip_tbls:
            xls_sheet_names.append(tbl)

    return env, data_src, src_db_schema, data_dictionary, xls_sheet_names, target_op_src_filename


def get_data_dictionary_args():
    """Get inputs specifying what mapping fields to use for the data dictionary"""
    field_mapping_data = read_ip_field_mapping_data()

    col_name_field = field_mapping_data["field_name_mappings"]["data_dic_col_name_field"]
    description_field = field_mapping_data["field_name_mappings"]["data_dic_descrip_field"]
    primary_key_field = field_mapping_data["field_name_mappings"]["data_dic_primary_key_field"]
    unique_field = field_mapping_data["field_name_mappings"]["data_dic_unique_field"]
    not_null_field = field_mapping_data["field_name_mappings"]["data_dic_not_null_field"]
    accepted_values_field = field_mapping_data["field_name_mappings"]["data_dic_accepted_values_field"]
    fk_constraint_table_field = field_mapping_data["field_name_mappings"]["data_dic_fk_constraint_table_field"]
    fk_constraint_key_field = field_mapping_data["field_name_mappings"]["data_dic_fk_constraint_key_field"]

    return col_name_field, description_field, primary_key_field, unique_field, not_null_field, accepted_values_field, fk_constraint_table_field, fk_constraint_key_field  # noqa
