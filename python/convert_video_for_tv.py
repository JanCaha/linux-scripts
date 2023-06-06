#!/usr/bin/env python3

import sys
import argparse
from pathlib import Path
import subprocess
import typing

import util_functions


def main(argv: typing.Optional[typing.Sequence[str]] = None):
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
        "output_file",
        help="Output File.",
        type=Path,
    )

    args = parser.parse_args()

    if not args.input_file.exist():
        util_functions.print_error("Input File does not exist.")
        return 1

    output_file: Path = args.output_file
    if output_file.suffix.lower() != ".mp4":
        output_file = output_file.parent / f"{output_file.stem}.mp4"

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

    util_functions.print_success(
        f"Created successfully!\n\tResult file: {args.source_file}"
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
