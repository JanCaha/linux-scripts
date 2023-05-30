#!/usr/bin/env python3

from bs4 import BeautifulSoup
from bs4.element import Tag
import requests
import re
import subprocess


import util_functions


def main():
    s = requests.Session()

    url = "https://posit.co/download/rstudio-desktop/"
    r = s.get(url)

    soup = BeautifulSoup(r.text, "html.parser")

    links = soup.findAll("a")

    deb_link = None

    link: Tag

    util_functions.print_color(
        "Checking out online version of RStudio.",
        util_functions.Colors.GREEN,
    )

    for link in links:
        href = link.get("href")
        if isinstance(href, str):
            match = re.match(
                "https://download1.rstudio.org/electron/jammy/amd64/.*-amd64.deb", href
            )
            if match:
                deb_link = match.group(0)
                deb_file = deb_link.replace(
                    "https://download1.rstudio.org/electron/jammy/amd64/", ""
                )
                version = deb_file.replace("rstudio-", "").replace("-amd64.deb", "")
                break

    existing_version = util_functions.get_install_variable("RStudioVersion")

    util_functions.print_color(
        f"Online version: {version}. Version stored in file: {existing_version}.",
        util_functions.Colors.GREEN,
    )

    if deb_link:
        if version != existing_version or not util_functions.binary_exist("rstudio"):
            util_functions.print_color(
                "Installing RStudio ...", util_functions.Colors.BLUE
            )
            subprocess.run(["wget", deb_link])
            subprocess.run(["sudo", "dpkg", "-i", deb_file])
            subprocess.run(
                [
                    "sed",
                    "-i",
                    f"s/^RStudioVersion=.*/RStudioVersion='{version}'/g",
                    util_functions.install_variables_file().as_posix(),
                ]
            )
            subprocess.run(["rm", deb_file])
        else:
            util_functions.print_color("Skipping RStudio instalation.")
    # url = "https://code.visualstudio.com/download"
    # r = s.get(url)

    # soup = BeautifulSoup(r.text, "html.parser")


if __name__ == "__main__":
    main()
