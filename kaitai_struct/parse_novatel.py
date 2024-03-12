#!/usr/bin/env python

"""
Parser for NovAtel GPS Receiver Logs

Usage:
   parse_novatel.py <input_file>
        [-h | --help]
        [--version]

Options:
  input_file   Puzzle Input File
  --version    Show version.
  -h --help    Show this screen.
"""

from kaitaistruct import KaitaiStream
from novatel import Novatel
from pprint import pprint
from docopt import docopt


class cmd_arguments:
    pass


def process_data(args):
    io = KaitaiStream(open(args.input_file, "rb"))
    message_counter = 0
    stats = {}
    stats[Novatel.FragmentedUdp] = 0

    while not io.is_eof():
        try:
            print(f"IO Position: { io.pos() } ", end="")
            nm = Novatel.NovatelMessage(io)
            print(f"Counter: { message_counter }: { nm.novatel_header_type }")

            if type(nm.novatel_header_type) is Novatel.RecordTypeUnknown:
                print(f"{nm.novatel_header_type.rec_type_unknown_data:X}")
                exit(0)
            print(f"nm.novatel_header_type: { nm.novatel_header_type }")
            message_counter += 1
        except EOFError:
            print(f"End of File")
        except:
            print(f"Unknown Exception")
            raise
    print(f"Exiting Clean")


def docopt_handler():
    args = cmd_arguments()
    arguments = docopt(__doc__)
    args.input_file = arguments["<input_file>"]
    return args


def main():
    """Main Function
    - Handle docopt parameters
    - Read input File
    - Compute Result
    - Print Output
    """
    args = docopt_handler()
    process_data(args)


if __name__ == "__main__":
    main()
