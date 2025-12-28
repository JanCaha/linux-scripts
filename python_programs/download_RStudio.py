#!/usr/bin/env python3

import re
import subprocess

import requests
import util_functions
from bs4 import BeautifulSoup
from bs4.element import Tag


def main():
    s = requests.Session()

    url = "https://posit.co/download/rstudio-desktop/"
    r = s.get(url)

    soup = BeautifulSoup(r.text, "html.parser")

    links = soup.findAll("a")

    deb_link = None

    link: Tag

    util_functions.print_info("Checking out online version of RStudio.")

    for link in links:
        href = link.get("href")
        if isinstance(href, str):
            match = re.match("https://download1.rstudio.org/electron/jammy/amd64/.*-amd64.deb", href)
            if match:
                deb_link = match.group(0)
                deb_file = deb_link.replace("https://download1.rstudio.org/electron/jammy/amd64/", "")
                version = deb_file.replace("rstudio-", "").replace("-amd64.deb", "")
                break

    existing_version = util_functions.get_install_variable("RStudioVersion")

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    if deb_link:
        if version != existing_version or not util_functions.binary_exist("rstudio"):
            util_functions.print_info("Installing RStudio ...")
            subprocess.run(["wget", deb_link], check=True)
            subprocess.run(["sudo", "dpkg", "-i", deb_file], check=True)
            subprocess.run(
                [
                    "sed",
                    "-i",
                    f"s/^RStudioVersion=.*/RStudioVersion='{version}'/g",
                    util_functions.install_variables_file().as_posix(),
                ],
                check=True,
            )
            subprocess.run(["rm", deb_file], check=True)

            util_functions.print_success("Installed new RStudio version.")
        else:
            util_functions.print_skip("Skipping RStudio installation.")


if __name__ == "__main__":
    main()
