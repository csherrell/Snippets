#!/usr/bin/env python
"""
file_handle.py

File Handling Examples

Usage:
  file_handle.py <input_file>
    [-v | --version]
    [-h | --help]

Options:
  input_file    Input File
  -v --version  Show this version
  -h --help     Show this screen

Examples:
  ./file_handle.py output.txt

Notes:
  PyLint and Black Compliant
  Print the doc strings. Module name without ".py"
  pydoc template

References:
  http://docopt.org/
  https://pypi.org/project/docopt/
  https://realpython.com/python-constants/
  https://www.geeksforgeeks.org/python-append-to-a-file/

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
__all__ = [
    "docopt_handler",
    "file_write",
    "file_append",
    "file_read",
]
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
    :param None: Takes no parameters
    :return arguments: (dict) arguments dictionary
    """
    arguments = docopt(__doc__, version=__version__)
    return arguments


def file_write(input_file):
    """
    Open a new file or overwrite file for writing
    :param input_file: (str) Filename
    :return: (None)
    """
    with open(input_file, "w", encoding="UTF-8") as file_handle:
        file_handle.write("This is a test\n")


def file_append(input_file):
    """
    Append to a file
    :param input_file: (str) Filename
    :return: (None)
    """
    with open(input_file, "a", encoding="UTF-8") as file_handle:
        file_handle.write("This is another test\n")


def file_read(input_file):
    """
    Read an input file
    :param input_file: (str) Filename
    :return: (None)
    """
    print(f"Processing: {input_file}")
    with open(input_file, encoding="UTF-8") as file:
        data_file = file.readlines()
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
    arguments = docopt_handler()
    file_write(arguments["<input_file>"])
    file_append(arguments["<input_file>"])
    file_read(arguments["<input_file>"])


if __name__ == "__main__":
    main()
