#!/usr/bin/env python3
"""
Python Version  : 3.8
* Name          : dbt_schema_generator.py
* Description   : Parses data dictionary to generate a dbt schema.yml file
* Created       : 15-06-2022
* Usage         : python3 dbt_schema_generator.py
"""

__author__ = "Paul Fry"
__version__ = "0.1"

import os
from time import time
import logging
import pandas as pd
import json
from jinja2 import Environment, FileSystemLoader

working_dir = os.getcwd()
# Set up a specific logger with our desired output level
logging.basicConfig(format="%(message)s")
logger = logging.getLogger("application_logger")
logger.setLevel(logging.INFO)
# By default, turn off log outputs. But if desired, change this arg to True
# logger.propagate = False

# jinja vars
template_dir = os.path.join(working_dir, "templates")
jinja_env = Environment(loader=FileSystemLoader(template_dir), autoescape=True)


def generate_schema_file(list_col_name_description_pairs, xls_sheet_name):
    """Generates the output (dbt) schema.yml file

    Args:   list_col_name_description_pairs (list): Contains column name/description pairs
            xls_sheet_name (string): Name of the xls sheet
    """
    START_TIME = time()
    logger.debug("Function called: generate_schema_file()")

    # generate the table name using the sheet name
    rendered_sql = jinja_env.get_template("schema_table.yml.j2").render(src_tbl_name=xls_sheet_name)
    with open((op_file), "a+") as op:
        op.write(rendered_sql)
        op.write("\n")

    # then write the colname/description pairs to the schema.yml file
    for pair in list_col_name_description_pairs:
        logger.info(pair)

        # fmt: on
        op = jinja_env.get_template("schema.yml.j2").render(
            col_name=pair[0], col_description=pair[1])
        with open((op_file), "a+") as op:
            op.write(op)
            op.write("\n")
        # fmt: off

    END_TIME = round(time() - START_TIME, 2)
    logger.debug(f"Generate_schema_file() finished in {END_TIME} seconds")

    return


def read_xls_file(ip_xls_file, xls_sheet_name):
    """Read and cleanse column name/descriptions from xls file.
    Args:   ip_xls_file (string): Input xls file
            xls_sheet_name (string): Name of the xls sheet
    Returns: list_col_name_description_pairs (list): List containing column name/description pairs
    """
    START_TIME = time()
    logger.debug("Function called: read_xls_file()")

    # create a data frame from the excel sheet & reset the index to iterate through the rows
    df = pd.read_excel(ip_xls_file, sheet_name=f"{xls_sheet_name}").reset_index()

    # create a list to store the colname/description pairs
    list_col_name_description_pairs = []

    for index, row in df.iterrows():
        # apply some basic cleansing
        col_name = row[f"{data_dic_colname}"].upper().replace(" ", "_")
        description = row[f"{data_dic_colname_description}"].replace(":", "-")
        list_col_name_description_pairs.append([col_name, description])
        logger.debug(list_col_name_description_pairs)

    END_TIME = round(time() - START_TIME, 2)
    logger.debug(f"Function finished: read_xls_file() finished in {END_TIME} seconds")

    return list_col_name_description_pairs


def get_ips():
    """Read input from config file. Returns shared input args used throughout the script."""
    START_TIME = time()
    logger.debug("Function called: get_ips()")

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    ip_xls_file = data["DataDictionaryParams"]["ip_xls_file"]
    xls_sheet_names = data["DataDictionaryParams"]["xls_sheet_names"]
    colname = data["DataDictionaryParams"]["data_dic_colname"]
    colname_description = data["DataDictionaryParams"]["data_dic_colname_description"]

    env = data["DataSourceParams"]["env"]
    division = data["DataSourceParams"]["division"]
    data_src = data["DataSourceParams"]["data_src"]
    src_db = data["DataSourceParams"]["src_db"]
    src_db_schema = data["DataSourceParams"]["src_db_schema"]

    END_TIME = round(time() - START_TIME, 2)
    logger.debug(f"Function finished: get_ips() finished in {END_TIME} seconds")

    return ip_xls_file, xls_sheet_names, colname, colname_description, env, division, data_src, src_db, src_db_schema


if __name__ == "__main__":
    # fetch inputs from config file
    ip_xls_file, xls_sheet_names, data_dic_colname, data_dic_colname_description, env, division, data_src, src_db, src_db_schema = get_ips()
    op_file = os.path.join(working_dir, "op", "schema.yml")

    # delete op file if it already exists
    if os.path.exists(op_file):
        logger.debug("Removing the existing file")
        os.remove(op_file)

    # first write the 'header' of the schema.yml file

    # fmt: on
    rendered_schema_header_op = jinja_env.get_template("schema_header.yml.j2").render(
        data_src=data_src,
        src_db=src_db,
        src_db_schema=src_db_schema
    )
    # fmt: off

    with open((op_file), "a+") as op:
        op.write(rendered_schema_header_op)
        op.write("\n")

    # extract data from each XLS sheet
    for xls_sheet_name in xls_sheet_names:
        logger.debug(f"sheet_name = {xls_sheet_name}")

        # extract the colname/description pairs
        list_col_name_description_pairs = read_xls_file(ip_xls_file, xls_sheet_name)

        # use each colname/description pair to generate the (dbt) schema.yml file, using jinja
        generate_schema_file(list_col_name_description_pairs, xls_sheet_name)
