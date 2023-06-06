#!/usr/bin/env python3

import argparse
import sys
import typing

import util_functions


def main(argv: typing.Optional[typing.Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="Get Keyfile",
        description="Get Keyfile.",
    )

    parser.add_argument(
        "keyring",
        help="Keyring filename.",
    )

    parser.add_argument(
        "keyring_url",
        help="Keyring url.",
    )

    parser.add_argument(
        "type",
        choices=["wget", "curl"],
        default="wget",
        help="Type of Keyring download.",
    )

    args = parser.parse_args()

    if args.type == "wget":
        ret_code, err = util_functions.wget(args.keyring, args.keyring_url)
    elif args.type == "curl":
        ret_code, err = util_functions.curl(args.keyring, args.keyring_url)

    if ret_code != 0:
        util_functions.print_error(f"Could not add given keyring!\n\t{err}")
        return ret_code

    util_functions.print_success(f"Added successfully!\n\tKeyring at: {args.keyring}")
    return 0


if __name__ == "__main__":
    util_functions.check_su()
    sys.exit(main())
