#!/usr/bin/env python
"""
template.py

Usage:
  template.py <input_file>
    [-v | --version]
    [-h | --help]

Options:
  input_file    Input File
  -v --version  Show this version
  -h --help     Show this screen

Examples:
  ./template.py ../test_data/test.txt

Notes:
  PyLint and Black Compliant
  Print the doc strings. Module name without ".py"
  pydoc template

References:
  http://docopt.org/
  https://pypi.org/project/docopt/
  https://realpython.com/python-constants/

"""


# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------

# stdlib imports --------------------------------------------------------------
from docopt import docopt

# Third-party imports ---------------------------------------------------------

# User Defined imports ---------------------------------------------------------------


# -----------------------------------------------------------------------------
# GLOBALS
# -----------------------------------------------------------------------------


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
    Process the docopt docstring arguments
    :param: None
    :return: docopt arguments dictionary
    """
    arguments = docopt(__doc__, version=__version__)
    return arguments


def read_file(input_file):
    """
    Read an input file
    :param: input_file Name
    :return: List of lines in the file
    """
    print(f"Processing: {input_file}")
    with open(input_file, encoding="UTF-8") as file:
        data_file = file.readlines()
    return data_file


def local_process(data_file, cmdargs):
    """
    Process a list of lines from a file
    Loop over the lines and strip the white space from beginning and end of string
    :param data_file: list - List of lines from the input file
    :param cmdargs: dict - command line arguments
    :return: string - "All Done"
    """
    print(f"{cmdargs}")
    for line in list(data_file):
        line = line.strip()
        print(f"{line}")
    return "All Done"


# -----------------------------------------------------------------------------
# RUNTIME PROCEDURE
# -----------------------------------------------------------------------------
def main():
    """
    Main Function
    : Process the docopt doc string
    : Read the input_file
    : Process the data
    """
    # description of the operations to be performed
    arguments = docopt_handler()
    data_file = read_file(arguments["<input_file>"])
    print(f"{local_process(data_file,arguments)}")


if __name__ == "__main__":
    main()
