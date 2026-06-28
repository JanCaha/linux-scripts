#!/usr/bin/env python3

import re
import subprocess
import xml.etree.ElementTree as ET

import requests
import util_functions
from packaging.version import Version


def _iter_bucket_keys(session: requests.Session, prefix: str):
    base_url = "https://download1.rstudio.org/"
    continuation_token = None
    ns = {"s3": "http://s3.amazonaws.com/doc/2006-03-01/"}

    while True:
        params = {"list-type": "2", "prefix": prefix, "max-keys": "1000"}
        if continuation_token:
            params["continuation-token"] = continuation_token

        response = session.get(base_url, params=params, timeout=30)
        response.raise_for_status()

        root = ET.fromstring(response.text)

        for item in root.findall("s3:Contents", ns):
            key_el = item.find("s3:Key", ns)
            if key_el is not None and key_el.text:
                yield key_el.text

        is_truncated = root.findtext("s3:IsTruncated", "false", ns)
        if is_truncated.lower() != "true":
            break

        continuation_token = root.findtext("s3:NextContinuationToken", None, ns)
        if not continuation_token:
            break


def main():
    session = requests.Session()
    prefix = "desktop/jammy/amd64/"

    deb_link = None
    deb_file = None
    version = None
    best_match = ("0.0.0", "")

    util_functions.print_info("Checking out online version of RStudio.")

    for key in _iter_bucket_keys(session, prefix):
        if not key.startswith(prefix):
            continue
        if not key.endswith("-amd64.deb"):
            continue

        candidate_file = key.replace(prefix, "")
        if not candidate_file.startswith("rstudio-"):
            continue

        candidate_version = candidate_file.replace("rstudio-", "").replace("-amd64.deb", "")
        # Remove build number (last -digits part, e.g., "-554" from "2022.07.1-554")
        candidate_version = re.sub(r"-\d+$", "", candidate_version)
        candidate = (candidate_version, key)

        try:
            version = Version(candidate[0])

            if best_match is None or Version(candidate[0]) > Version(best_match[0]):
                best_match = candidate

        except Exception:
            continue

    if best_match is not None:
        version, best_key = best_match
        deb_link = f"https://download1.rstudio.org/{best_key}"
        deb_file = best_key.replace(prefix, "")

    existing_version = util_functions.get_install_variable("RStudioVersion")

    util_functions.print_info(f"\tOnline version: {version}. Version stored in file: {existing_version}.")

    if deb_link and deb_file and version:
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
    else:
        util_functions.print_skip("No matching RStudio .deb key found in XML listing.")


if __name__ == "__main__":
    main()
