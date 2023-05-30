#!/usr/bin/env python3

from bs4 import BeautifulSoup
from bs4.element import Tag
import requests
import re
import subprocess
import sys

import util_functions


def main():
    s = requests.Session()

    url = "https://freefilesync.org"
    r = s.get(url + "/download.php")

    soup = BeautifulSoup(r.text, "html.parser")

    links = soup.findAll("a")

    tar_link = None

    link: Tag
    version: str
    file: str

    util_functions.print_color(
        "Checking out online version of FreeFileSync.",
        util_functions.Colors.GREEN,
    )

    for link in links:
        href = link.get("href")
        if isinstance(href, str):
            match = re.match("/download/FreeFileSync_.+_Linux.tar.gz", href)
            if match:
                tar_link = match.group(0)
                version = tar_link.split("_")[1]
                file = tar_link.replace("/download/", "")
                break

    existing_version = util_functions.get_install_variable("FreeFileSyncLastVersion")

    util_functions.print_color(
        f"\tOnline version: {version}. Version stored in file: {existing_version}.",
        util_functions.Colors.GREEN,
    )

    if version != existing_version or not util_functions.binary_exist("freefilesync"):
        subprocess.run(["wget", url + tar_link])
        subprocess.run(["tar", "-xvf", file])
        unzipped = file.replace("Linux", "Install")
        unzipped = unzipped.replace("tar.gz", "run")
        print(unzipped)
        subprocess.run(["chmod", "+x", unzipped])
        subprocess.run(["sudo", f"./{unzipped}"])
        subprocess.run(
            [
                "sed",
                "-i",
                f"s/^FreeFileSyncLastVersion=.*/FreeFileSyncLastVersion='{version}'/g",
                sys.argv[1],
            ]
        )
    else:
        util_functions.print_color("Skipping FreeFileSync installation.")


if __name__ == "__main__":
    main()
