#!/usr/bin/env python3

import argparse
import typing

import util_functions


def main(argv: typing.Optional[typing.Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="Create File Source",
        description="Create new File Source.",
    )

    parser.add_argument(
        "keyring",
        help="Keyring filename.",
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

    parser.add_argument(
        "--architecture",
        default=None,
        help="Architecture to add.",
    )

    args = parser.parse_args(argv)

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
        args.architecture,
    )

    util_functions.print_success(f"Created successfully!\n\tSource file at: {args.source_file}")

    return 0


if __name__ == "__main__":
    util_functions.check_su()
    main()
