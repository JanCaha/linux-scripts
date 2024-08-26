#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys
import typing
from pathlib import Path

import util_functions


def main(_argv: typing.Optional[typing.Sequence[str]] = None):
    default_suffix = ".pdf"

    parser = argparse.ArgumentParser(
        prog="Convert Ebook to PDF",
        description="Convert Ebook to PDF file.",
    )

    args = parser.parse_args()

    if not args.input_file.exists():
        util_functions.print_error("Input File does not exist.")
        return 1

    if args.output_file:
        output_file: Path = args.output_file
        if output_file.suffix.lower() != default_suffix:
            output_file = output_file.parent / f"{output_file.stem}{default_suffix}"
    else:
        output_file = args.input_file.with_suffix(default_suffix)

    if output_file.exists():
        output_file = output_file.parent / f"{output_file.stem}_converted{output_file.suffix}"

    util_functions.print_info(f"Saving as: {output_file.name}")

    process = subprocess.Popen(
        [
            "ebook-convert",
            args.input_file.as_posix(),
            output_file.as_posix(),
        ],
        stdout=subprocess.PIPE,
        env=dict(os.environ, **{"QTWEBENGINE_CHROMIUM_FLAGS": "--disable-gpu"}),
    )

    process.wait()

    util_functions.print_success(f"Created successfully!\n\tResult file: {output_file.as_posix()}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
