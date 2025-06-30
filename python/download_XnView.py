#!/usr/bin/env python3

import re
import subprocess

import requests
import util_functions
from bs4 import BeautifulSoup
from bs4.element import Tag


def main():
    s = requests.Session()

    url = "https://www.xnview.com/update_xnviewmp.html"
    r = s.get(url)

    soup = BeautifulSoup(r.text, "html.parser")

    h5 = soup.find("p", class_="h5")

    deb_link = None

    util_functions.print_info("Checking out online version of XnView.")

    text = h5.get_text()
    match = re.search(r"\d+\.\d+\.\d+", text)
    version = match.group(0) if match else exit(1)

    existing_version = util_functions.get_install_variable("XnViewVersion")

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    path_deb_file = "/tmp/XnViewMP-linux-x64.deb"

    if version != existing_version:
        util_functions.print_info("Installing XnView ...")
        subprocess.run(
            [
                "wget",
                "-O",
                path_deb_file,
                "https://www.xnview.com/download.php?update=1&file=XnViewMP-linux-x64.deb",
            ],
            check=True,
        )
        subprocess.run(["sudo", "dpkg", "-i", path_deb_file], check=True)
        subprocess.run(
            [
                "sed",
                "-i",
                f"s/^XnViewVersion=.*/XnViewVersion='{version}'/g",
                util_functions.install_variables_file().as_posix(),
            ],
            check=True,
        )
        subprocess.run(["rm", path_deb_file], check=True)

        util_functions.print_success("Installed new XnView version.")
    else:
        util_functions.print_skip("Skipping XnView installation.")


if __name__ == "__main__":
    main()
