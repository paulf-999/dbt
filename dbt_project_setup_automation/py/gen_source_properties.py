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
import pandas as pd
from common import logger, jinja_env_source
import inputs


def read_xls_file(data_dictionary, xls_sheet_name):
    """Read and cleanse column name/descriptions from xls file.
    Args:   data_dictionary (string): Input xls file
            xls_sheet_name (string): Name of the xls sheet
    Returns: list_col_name_description_pairs (list): List containing column name/description pairs
    """

    col_name_field, description_field, unique_key_field, accepted_values_field, rel_table_field, rel_field = inputs.get_data_dictionary_args()

    # create a data frame from the excel sheet & reset the index to iterate through the rows
    df = pd.read_excel(data_dictionary, sheet_name=xls_sheet_name, skiprows=2).fillna("").reset_index()

    logger.debug(df)
    # create a list to store the col_name/description pairs
    list_col_name_description_pairs = []

    for index, row in df.iterrows():
        # apply some basic cleansing
        col_name = row[f"{col_name_field}"].upper()
        description = row[f"{description_field}"]
        unique_key = row[f"{unique_key_field}"]
        accepted_values = row[f"{accepted_values_field}"]
        relationships_table = row[f"{rel_table_field}"]
        relationships_field = row[f"{rel_field}"]
        list_col_name_description_pairs.append(
            [col_name, description, unique_key, accepted_values, relationships_table, relationships_field]
        )
        logger.debug(list_col_name_description_pairs)

    return list_col_name_description_pairs


if __name__ == "__main__":

    # fetch inputs from config file
    data_src, src_db, src_db_schema, data_dictionary, xls_sheet_names, target_op_src_filename = inputs.get_ips()

    # first write the 'header' of the source.yml file
    # fmt: off
    rendered_schema_header = jinja_env_source.get_template("source_header.yml.j2").render(
        data_src=data_src, src_db=src_db, src_db_schema=src_db_schema)
    # fmt: on

    # TODO - put the folder check logic into a function
    target_dir = f"op/{data_src}/"

    # make the target dir if it doesn't exist
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    op_sources_file = os.path.join(target_dir, target_op_src_filename)

    with open((op_sources_file), "w") as op_src_file:
        op_src_file.write(f"{rendered_schema_header}\n")

    # TODO: potentially put this for loop into a function
    # extract data from each XLS sheet
    for xls_sheet_name in xls_sheet_names:
        logger.debug(f"sheet_name = {xls_sheet_name}")

        # extract the col_name/description pairs
        list_col_name_description_pairs = read_xls_file(data_dictionary, xls_sheet_name)
        logger.debug(list_col_name_description_pairs)

        # use each col_name/description pair to generate the (dbt) source.yml file, using a jinja template
        rendered_schema_tbl = jinja_env_source.get_template("source_table.yml.j2").render(src_tbl_name=xls_sheet_name)

        # store the sum of the rendered field/comments generated
        sum_rendered_table_pairs_op = ""

        for pair in list_col_name_description_pairs:
            logger.debug(pair)

            # fmt: off
            rendered_table_pairs = jinja_env_source.get_template("source.yml.j2").render(
                col_name=pair[0].strip(),
                col_description=pair[1].strip(),
                unique_key_field=pair[2],
                accepted_values_field=pair[3],
                relationships_table_field=pair[4],
                relationships_field=pair[5],
            )
            # fmt: off
            sum_rendered_table_pairs_op += f"\n{rendered_table_pairs}"

        logger.debug(sum_rendered_table_pairs_op)

        with open((op_sources_file), "a+") as op_src_file:
            op_src_file.write(f"{rendered_schema_tbl}")
            op_src_file.write(f"{sum_rendered_table_pairs_op}\n")
