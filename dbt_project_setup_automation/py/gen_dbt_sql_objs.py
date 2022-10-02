#!/usr/bin/env python3
"""
Python Version  : 3.8
* Name          : gen_dbt_sql_objs.py
* Description   : Workflow generation script
                : Used to generate dbt snapshot/incremental files in batch
                : Uses Jinja templates with input tables to generate required SQL files
* Created       : 23-06-2022
* Usage         : python3 gen_dbt_sql_objs.py <jinja template>
"""

__author__ = "Paul Fry"
__version__ = "0.1"

import os
import sys
import json
import pandas as pd
from common import logger, working_dir, jinja_env


def render_jinja_and_gen_sql():
    """Iterate through the input tables for a division and render/generate SQL op files"""
    logger.debug("Function called: render_jinja_and_gen_sql()")
    for division, src_tables in div_tbls_dict.items():
        logger.info("--------------------------------")
        logger.info(f"# Division = {division.upper()}")
        logger.info("--------------------------------")

        # only fetch the tables for the targeted division
        if division == ip_division:
            for src_table in src_tables:
                # read in the CSV file to determine 'unique_key' & 'load_date_field' fields
                unique_key, updated_at_field = read_csv_data_dictionary(src_table)

                # render the table output using this
                # fmt: off
                rendered_sql = jinja_env.get_template(f"{jinja_template}.sql.j2").render(
                    source_name=division,
                    src_tbl_name=src_table,
                    updated_at_field=updated_at_field,
                    unique_key=unique_key
                )
                # fmt: on

                target_dir = f"{division}/{jinja_template}"

                # make the target dir if it doesn't exist
                if not os.path.exists(target_dir):
                    os.makedirs(target_dir)

                op_filepath = os.path.join(working_dir, "op", f"{division}_{src_table}.sql")

                with open((op_filepath), "w") as op_sql_file:
                    op_sql_file.write(rendered_sql)

    return


# TODO: revert this to instead read an xlsx file
def read_csv_data_dictionary(src_table):
    """Parse CSV data dictionary"""
    logger.debug("Function called: read_csv_data_dictionary()")
    logger.info(f"src_table = {src_table}")
    logger.debug("---------------------------")

    # read in data dictionary as df to determine 'unique_key' & 'load_date_field' fields
    df = pd.read_csv(data_dictionary, skiprows=2).reset_index()
    # filter data frame to only return the metadata for the table we're interested in
    df = df.loc[(df["division"] == ip_division.upper()) & (df["table"] == src_table)]
    logger.debug(df)

    unique_key = df["unique_key"].values[0]
    updated_at_field = df["updated_at_field"].values[0]

    logger.debug(f"unique_key = {unique_key}")
    logger.debug(f"load_date_field = {updated_at_field}")

    return unique_key, updated_at_field


def get_ips():
    """Read input from config file. Returns shared input args used throughout the script."""
    logger.debug("Function called: get_ips()")

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    ip_division = data["general_params"]["data_src"]
    data_dictionary = data["data_dictionary_params"]["data_dictionary"]

    div_tbls_dict = {}
    div_tbls_dict["ofw"] = data["data_src_params"]["src_tables"]["ofw_src_tables"]
    # div_tbls_dict["bun"] = data["data_src_params"]["division_src_tables"]["BUNSrcTables"]
    # div_tbls_dict["kmt"] = data["data_src_params"]["division_src_tables"]["KMTSrcTables"]
    # div_tbls_dict["cat"] = data["data_src_params"]["division_src_tables"]["CATSrcTables"]
    # div_tbls_dict["tgt"] = data["data_src_params"]["division_src_tables"]["TGTSrcTables"]

    return ip_division, data_dictionary, div_tbls_dict


def read_excel_data_dictionary(src_table, sheet_name):
    """Parse xls data dictionary"""
    logger.debug("Function called: read_csv_data_dictionary()")
    logger.info(f"src_table = {src_table}")
    logger.debug("---------------------------")

    # create a data frame from the excel sheet & reset the index to iterate through the rows
    df = pd.read_excel(data_dictionary, sheet_name=f"{sheet_name}").fillna("").reset_index()
    # use row 1 values as the header
    df = pd.DataFrame(df.values[1:], columns=df.iloc[0])

    return df


if __name__ == "__main__":
    # TODO - move elsewhere. determine the jinja template we require from user input
    # validate user input
    if len(sys.argv) < 2:
        logger.info("\nError: No input arguments provided.\n")
        logger.info("Usage: python3 gen_dbt_sql_objs.py <jinja_template_name>\n")
        logger.info("Available jinja templates are: 'snapshot' and 'incremental'.\n")
        logger.info("Example: python3 gen_dbt_sql_objs.py snapshot")
        raise (SystemExit)
    else:
        # TODO: validate the input as either 'snapshot' or 'incremental'.

        jinja_template = sys.argv[1]

        # fetch list of div tables
        ip_division, data_dictionary, div_tbls_dict = get_ips()

        # call main routine
        render_jinja_and_gen_sql()
