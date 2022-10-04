import logging
import os

from jinja2 import Environment
from jinja2 import FileSystemLoader

# Set up a specific logger with our desired output level
logging.basicConfig(format="%(message)s")
logger = logging.getLogger("application_logger")
logger.setLevel(logging.INFO)

working_dir = os.getcwd()

# jinja vars
template_dir = os.path.join(working_dir, "templates", "jinja_templates")
jinja_env = Environment(loader=FileSystemLoader(template_dir), autoescape=True)

source_template_dir = os.path.join(working_dir, "templates", "jinja_templates", "source_properties")
jinja_env_source = Environment(loader=FileSystemLoader(source_template_dir), autoescape=True)
