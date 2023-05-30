#!/usr/bin/env python3

import argparse
import sys

import util_functions


def main():
    parser = argparse.ArgumentParser(
        prog="Create PPA Source",
        description="Create new PPA Source.",
    )

    parser.add_argument(
        "keyring",
        help="Keyring filename.",
    )

    parser.add_argument(
        "keyring_fingerprint",
        help="Keyring fingerprint filename.",
    )

    parser.add_argument(
        "source_file",
        help="Source file.",
    )

    parser.add_argument(
        "source_url",
        help="Source URL.",
    )

    parser.add_argument("--add-src", action="store_true", help="Add deb-src.")

    parser.add_argument(
        "--distro_code_name",
        default=util_functions.ubuntu_name(),
        help="Name of the distro to add.",
    )

    parser.add_argument(
        "--component",
        default="main",
        help="Component to add.",
    )

    args = parser.parse_args()

    ret_code, err = util_functions.add_key(args.keyring, args.keyring_fingerprint)

    if ret_code == 0:
        util_functions.print_color(
            f"Could not add given keyring!\n\t{err}", util_functions.Colors.RED
        )
        sys.exit(ret_code)

    source_type = "deb"
    if args.add_src:
        source_type += " deb-src"

    util_functions.create_source_file(
        args.source_file,
        source_type,
        args.source_url,
        args.distro_code_name,
        args.component,
        args.keyring,
    )

    util_functions.print_color(
        f"Created successfully!\n\tSource file at: {args.source_file}\n\tKeyring at: {args.keyring}",
        util_functions.Colors.GREEN,
    )


if __name__ == "__main__":
    util_functions.check_su()
    main()
