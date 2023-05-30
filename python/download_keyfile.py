#!/usr/bin/env python3

import argparse
import sys

import util_functions


def main():
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
        util_functions.print_color(
            f"Could not add given keyring!\n\t{err}", util_functions.Colors.RED
        )
        sys.exit(ret_code)

    util_functions.print_color(
        f"Added successfully!\n\tKeyring at: {args.keyring}",
        util_functions.Colors.GREEN,
    )


if __name__ == "__main__":
    util_functions.check_su()
    main()
