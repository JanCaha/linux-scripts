#!/usr/bin/env python3

import re
import subprocess

import requests
import util_functions
from bs4 import BeautifulSoup
from bs4.element import Tag


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

    util_functions.print_info("Checking out online version of FreeFileSync.")

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

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    if version != existing_version or not util_functions.binary_exist("freefilesync"):
        util_functions.print_info("Installing FreeFileSync ...")

        subprocess.run(["wget", url + tar_link], check=True)
        subprocess.run(["tar", "-xvf", file], check=True)
        unzipped = file.replace("Linux", "Install")
        unzipped = unzipped.replace("tar.gz", "run")
        print(unzipped)
        subprocess.run(["chmod", "+x", unzipped], check=True)
        subprocess.run(["sudo", f"./{unzipped}"], check=True)
        subprocess.run(
            [
                "sed",
                "-i",
                f"s/^FreeFileSyncLastVersion=.*/FreeFileSyncLastVersion='{version}'/g",
                util_functions.install_variables_file().as_posix(),
            ],
            check=True,
        )

        util_functions.print_success("Installed new FreeFileSync version.")
    else:
        util_functions.print_skip("Skipping FreeFileSync installation.")


if __name__ == "__main__":
    main()
