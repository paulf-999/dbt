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
    for data_src, src_tables in data_src_tbls_dict.items():
        logger.info("--------------------------------")
        logger.info(f"data_src = {data_src}")
        logger.info("--------------------------------")

        # only fetch the tables for the targeted division
        if data_src == data_src:
            for src_table in src_tables:
                # read in the CSV file to determine 'unique_key' & 'load_date_field' fields
                unique_key, updated_at_field = read_summary_data_src_metadata(data_src, src_table)

                # render the table output using this
                # fmt: off
                rendered_sql = jinja_env.get_template(f"{ip_jinja_template}.sql.j2").render(
                    source_name=data_src,
                    src_tbl_name=src_table,
                    updated_at_field=updated_at_field,
                    unique_key=unique_key
                )
                # fmt: on

                target_dir = f"op/{data_src}/{ip_jinja_template}"

                # make the target dir if it doesn't exist
                if not os.path.exists(target_dir):
                    os.makedirs(target_dir)

                op_filepath = os.path.join(target_dir, f"{src_table}.sql")

                with open((op_filepath), "w") as op_sql_file:
                    op_sql_file.write(rendered_sql)

    return


def read_summary_data_src_metadata(data_src, src_table):
    """Parse CSV data dictionary"""
    logger.debug("Function called: read_summary_data_src_metadata()")
    logger.info("--------------------------------")
    logger.info(f"src_table = {src_table}")
    logger.info("--------------------------------")

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    summary_data_src_metadata = data["general_params"]["summary_data_src_metadata"]
    data_src_metadata_sheet_name = data["general_params"]["data_src_metadata_sheet_name"]

    # read in data dictionary as df to determine 'unique_key' & 'load_date_field' fields
    df = pd.read_excel(summary_data_src_metadata, sheet_name=data_src_metadata_sheet_name, skiprows=2).fillna("").reset_index()

    # logger.info(df)

    # filter data frame to only return the metadata for the table we're interested in
    df = df.loc[(df["data_src"] == data_src) & (df["table"] == src_table)]

    unique_key = df["unique_key"].values[0]
    updated_at_field = df["updated_at_field"].values[0]

    logger.info(f"unique_key = {unique_key}")
    logger.info(f"updated_at_field = {updated_at_field}")

    return unique_key, updated_at_field


def get_ips():
    """Read input from config file. Returns shared input args used throughout the script."""
    logger.debug("Function called: get_ips()")

    with open(os.path.join(working_dir, "ip", "config.json")) as f:
        data = json.load(f)

    data_src = data["general_params"]["data_src"]

    data_src_tbls_dict = {}
    data_src_tbls_dict["data_src_a"] = data["data_src_params"]["data_src_tables"]["src_tables"]
    # data_src_tbls_dict["ofw"] = data["data_src_params"]["src_tables"]["ofw_src_tables"]
    # data_src_tbls_dict["bun"] = data["data_src_params"]["src_tables"]["BUNSrcTables"]
    # data_src_tbls_dict["kmt"] = data["data_src_params"]["src_tables"]["KMTSrcTables"]
    # data_src_tbls_dict["cat"] = data["data_src_params"]["src_tables"]["CATSrcTables"]
    # data_src_tbls_dict["tgt"] = data["data_src_params"]["src_tables"]["TGTSrcTables"]

    return data_src, data_src_tbls_dict


if __name__ == "__main__":

    # validate user input
    if len(sys.argv) < 2:
        logger.error("\nError: No input argument provided.\n")
        logger.error("Usage: python3 gen_dbt_sql_objs.py <ip_jinja_template_name>\n")
        logger.error("Available jinja templates are: 'snapshot' and 'incremental'.\n")
        logger.error("Example: python3 gen_dbt_sql_objs.py snapshot")
        raise SystemExit
    else:
        ip_jinja_template = sys.argv[1]
        valid_cmd_line_inputs = {
            "snapshot": 1,
            "incremental": 2,
        }

        try:
            # validate cmd line input
            validate_cmd_line_ip = valid_cmd_line_inputs[ip_jinja_template]

            # fetch list of div tables
            data_src, data_src_tbls_dict = get_ips()

            # call main routine
            render_jinja_and_gen_sql()

        except KeyError:
            logger.error(f"\nError: Invalid input argument provided: '{ip_jinja_template}'.\n")
            logger.error("Usage: python3 gen_dbt_sql_objs.py <ip_jinja_template_name>\n")
            logger.error("Available jinja templates are: 'snapshot' and 'incremental'.\n")
            logger.error("Example: python3 gen_dbt_sql_objs.py snapshot")
