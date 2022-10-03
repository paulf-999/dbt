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
import json
from common import working_dir


def get_ips():
    """Read input from config file. Returns shared input args used throughout the script."""

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    data_src = data["general_params"]["data_src"]
    src_db = data["data_src_params"]["src_db"]
    src_db_schema = data["data_src_params"]["src_db_schema"]

    # data dictionary inputs
    data_dictionary = data["data_dictionary_params"]["data_dictionary"]
    xls_sheet_names = data["data_dictionary_params"]["data_dic_sheet_names"]
    target_op_src_filename = data["general_params"]["target_op_src_filename"].replace("{data_src}", data_src)

    return data_src, src_db, src_db_schema, data_dictionary, xls_sheet_names, target_op_src_filename


def get_data_dictionary_args():
    """Read input from config file. Returns shared input args used throughout the script."""

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    col_name_field = data["data_dictionary_params"]["data_dic_col_name_field"]
    description_field = data["data_dictionary_params"]["data_dic_descrip_field"]
    unique_key_field = data["data_dictionary_params"]["data_dic_unique_key_field"]
    accepted_values_field = data["data_dictionary_params"]["data_dic_accepted_values_field"]
    rel_table_field = data["data_dictionary_params"]["data_dic_relationships_table_field"]
    rel_field = data["data_dictionary_params"]["data_dic_relationships_field"]

    return col_name_field, description_field, unique_key_field, accepted_values_field, rel_table_field, rel_field
