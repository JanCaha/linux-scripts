#!/usr/bin/env python3

import subprocess
from pathlib import Path

import util_functions


def main():

    util_functions.print_info("Checking out online version of Quarto.")

    command = [
        "gh",
        "release",
        "list",
        "-R",
        "quarto-dev/quarto-cli",
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

    existing_version = util_functions.get_install_variable("QuartoVersion")

    if version == existing_version:
        util_functions.print_skip("Skipping Quarto installation.")
        return

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    command = [
        "gh",
        "release",
        "download",
        "-R",
        "quarto-dev/quarto-cli",
        "-p",
        "quarto*linux-amd64.deb",
    ]

    result = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        check=True,
    )

    for file in Path.cwd().glob("quarto*.deb"):
        deb_file = file.as_posix()

    if deb_file:
        subprocess.run(["sudo", "dpkg", "-i", deb_file], check=True)
        subprocess.run(
            [
                "sed",
                "-i",
                f"s/^QuartoVersion=.*/QuartoVersion='{version}'/g",
                util_functions.install_variables_file().as_posix(),
            ],
            check=True,
        )
        subprocess.run(["rm", deb_file], check=True)

        util_functions.print_success("Installed new Quarto version.")
    else:
        util_functions.print_skip("Skipping Quarto installation.")


if __name__ == "__main__":
    main()
