#!/usr/bin/env python3

import sys
import argparse
from pathlib import Path
import subprocess

import util_functions


def main():
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
        print("Input File does not exist.", file=sys.stderr)
        sys.exit(1)

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

    print(f"Created successfully! {args.source_file}")


if __name__ == "__main__":
    main()
