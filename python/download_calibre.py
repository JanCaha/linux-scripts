#!/usr/bin/env python3

import subprocess
from pathlib import Path

import util_functions


def main():

    command = [
        "gh",
        "release",
        "list",
        "-R",
        "kovidgoyal/calibre",
        "--exclude-pre-releases",
        "--exclude-drafts",
        "--json",
        "tagName",
        "--jq",
        ".[0].tagName",
    ]

    result = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        check=True,
    )

    version = result.stdout.decode("utf-8").replace("\n", "")

    existing_version = util_functions.get_install_variable("CalibreVersion")

    if version == existing_version:
        print("")
    else:
        print(version)


if __name__ == "__main__":
    main()
