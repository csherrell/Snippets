#!/usr/bin/env python

# Order of Precedence
# Command line options
# Configuration file that's name is declared on the command line
# Environment Variable
# Local configuration file (if exists)
# Global configuration file (if exists)

"""
precedence_of_options.py

Usage:
  precedence_of_options.py
    [-c CONFIG_FILE | --config_file CONFIG_FILE] 
    [-v | --version]
    [-h | --help]

Options:
  -c CONFIG_FILE --config_file CONFIG_FILE  Project configuration file.
  -v --version  Show this version
  -h --help     Show this screen

Examples:
  ./precedence_of_options.py ../my_config_file.toml

Notes:
  PyLint and Black Compliant
  Print the doc strings. Module name without ".py"
  `pydoc precedence_of_options`

References:
  http://docopt.org/
  https://pypi.org/project/docopt/
  https://realpython.com/python-constants/

"""
# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
# stdlib imports --------------------------------------------------------------
import os
import sys
import tomllib

# Third-party imports ---------------------------------------------------------
from docopt import docopt

# User Defined imports ---------------------------------------------------------------


# -----------------------------------------------------------------------------
# GLOBALS
# -----------------------------------------------------------------------------
# Environment Variable: MYPROJECT_CONFIG
LOCAL_CONFIGURATION_FILE_NAME = os.path.expanduser("myproject.toml")
GLOBAL_CONFIGURATION_FILE_NAME = os.path.expanduser("~/myproject.toml")


# -----------------------------------------------------------------------------
# CONSTANTS
# -----------------------------------------------------------------------------
__all__ = ["docopt_handler", "local_process"]
__author__ = "Chad S. Sherrell"
__version__ = "0.0.1"


# -----------------------------------------------------------------------------
# LOCAL UTILITIES
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# CLASSES
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
def docopt_handler():
    """
    Process the docopt arguments string
    :param: None
    :return: docopt arguments dictionary
    """

    arguments = docopt(__doc__, version=__version__)

    myproject_config_environment_variable = os.getenv("MYPROJECT_CONFIG")

    if myproject_config_environment_variable:
        myproject_config_environment_variable = os.path.expanduser(
            myproject_config_environment_variable
        )

    if arguments.config_file:
        arguments.config_file = os.path.expanduser(arguments.config_file)
        print(f"Trying: {arguments.config_file}")
        if os.path.isfile(arguments.config_file):
            print(f"Using Command Line Configuration File: {arguments.config_file}")
        else:
            print(f"ERROR: {arguments.config_file} does not exist")
            sys.exit(1)
    elif myproject_config_environment_variable:
        print("Checking Environment Variable")
        if os.path.isfile(myproject_config_environment_variable):
            print(
                "Using MYPROJECT_CONFIG Enviornment Configuration File: "
                + f"{myproject_config_environment_variable}"
            )
            arguments.config_file = myproject_config_environment_variable
        else:
            print(f"ERROR: {myproject_config_environment_variable} file does not exist")
            sys.exit(1)
    elif os.path.isfile(LOCAL_CONFIGURATION_FILE_NAME):
        print(f"Using Local Configuration File: {LOCAL_CONFIGURATION_FILE_NAME}")
        arguments.config_file = LOCAL_CONFIGURATION_FILE_NAME
    elif os.path.isfile(GLOBAL_CONFIGURATION_FILE_NAME):
        print(f"Using Global Configuration File: {GLOBAL_CONFIGURATION_FILE_NAME}")
        arguments.config_file = GLOBAL_CONFIGURATION_FILE_NAME
    else:
        print("No Configuration File Present")
    return arguments


def local_process(arguments):
    """
    Process a list of lines from a file
    Loop over the lines and strip the white space from beginning and end of string
    :param data_file: list - List of lines from the input file
    :param cmdargs: dict - command line arguments
    :return: string - "All Done"
    """
    print(f"{arguments}")
    if arguments.config_file:
        with open(arguments.config_file, "rb") as toml_config_file:
            project_settings = tomllib.load(toml_config_file)
            print(f"{project_settings}")
    return "All Done"


# -----------------------------------------------------------------------------
# RUNTIME PROCEDURE
# -----------------------------------------------------------------------------
def main():
    """
    Main Function
    : Process the docopt doc string
    : Process the data
    """
    # description of the operations to be performed
    arguments = docopt_handler()
    local_process(arguments)
    print(f"Arguments: {arguments}")
    print("Exiting")


if __name__ == "__main__":
    main()
