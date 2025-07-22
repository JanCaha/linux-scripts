#!/usr/bin/env python3

import re
import subprocess
import sys

import requests
import util_functions
from bs4 import BeautifulSoup
from bs4.element import Tag


def main():
    s = requests.Session()

    url = "https://dlang.org/download.html"
    r = s.get(url)

    soup = BeautifulSoup(r.text, "html.parser")

    a = soup.find("a", href=lambda x: x and "dmd" in x and "amd64" in x and ".deb" in x and ".sig" not in x)

    util_functions.print_info("Checking out online version of DLang.")

    if a is None:
        sys.exit("No download link found for DLang.")

    link = a.get("href")

    match = re.search(r"\d+\.\d+\.\d+-\d+", link)
    version = match.group(0) if match else exit(1)

    existing_version = util_functions.get_install_variable("DLangVersion")

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    path_deb_file = "/tmp/Dlang.deb"

    if version != existing_version:
        util_functions.print_info("Installing DLang ...")
        subprocess.run(
            [
                "wget",
                "-O",
                path_deb_file,
                link,
            ],
            check=True,
        )
        subprocess.run(["sudo", "dpkg", "-i", path_deb_file], check=True)
        subprocess.run(
            [
                "sed",
                "-i",
                f"s/^DLangVersion=.*/DLangVersion='{version}'/g",
                util_functions.install_variables_file().as_posix(),
            ],
            check=True,
        )
        subprocess.run(["rm", path_deb_file], check=True)

        util_functions.print_success("Installed new DLang version.")
    else:
        util_functions.print_skip("Skipping DLang installation.")


if __name__ == "__main__":
    main()
