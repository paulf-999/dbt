# High-level summary

Python script used to generate DBT's `schema.yml` file from an input data dictionary. Doing this avoids the need to manually create the required metadata needed by DBT.

### Technologies used

- Python
- Jinja template(s)
- Pandas

### Prerequisites

1. Populate `ip/config.json` with your required inputs
2. Ensure you have installed the libraries `pandas` and `openpyxl` (see `requirements.txt`.)
