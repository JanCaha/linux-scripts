#!/usr/bin/env python3

import argparse
import subprocess
import sys
import typing
from pathlib import Path

import util_functions


def main(argv: typing.Optional[typing.Sequence[str]] = None):
    default_suffix = ".mp4"

    parser = argparse.ArgumentParser(
        prog="Convert Video for Samsung TV",
        description="Convert video for Samsung TV.",
    )

    parser.add_argument(
        "input_file",
        help="Input File.",
        type=Path,
    )

    parser.add_argument(
        "-o",
        "--output_file",
        help="Output File.",
        type=Path,
        required=False,
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

    subprocess.Popen(
        [
            "ffmpeg",
            "-i",
            args.input_file.as_posix(),
            "-c:v",
            "libx264",
            "-c:a",
            "aac",
            "-vbr",
            "5",
            "-sn",
            "-map_chapters",
            "-1",
            output_file.as_posix(),
        ],
        stdout=subprocess.PIPE,
    )

    util_functions.print_success(f"Created successfully!\n\tResult file: {args.source_file}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
