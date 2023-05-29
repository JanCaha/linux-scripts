from bs4 import BeautifulSoup
from bs4.element import Tag
import requests
import re
import subprocess
import sys

s = requests.Session()

url = 'https://posit.co/download/rstudio-desktop/'
r = s.get(url)

soup = BeautifulSoup(r.text, "html.parser")

links = soup.findAll("a")

deb_link = None

link: Tag

for link in links:
    href = link.get("href")
    if isinstance(href, str):
        match = re.match("https://download1.rstudio.org/electron/jammy/amd64/.*-amd64.deb", href)
        if match:
            deb_link = match.group(0)
            deb_file = deb_link.replace("https://download1.rstudio.org/electron/jammy/amd64/", "")
            version = deb_file.replace("rstudio-", "").replace("-amd64.deb", "")
            break

print(f"Online version: {version}. Version stored in file: {sys.argv[2]}.")

if deb_link:
    if version != sys.argv[2]:
        print("Installing RStudio ...")
        subprocess.run(["wget", deb_link])
        subprocess.run(["sudo", "dpkg", "-i", deb_file])
        subprocess.run(["sed", "-i", f"s/^RStudioVersion=.*/RStudioVersion='{version}'/g", sys.argv[1]])
        subprocess.run(["rm", deb_file])
    else:
        print("Skipping RStudio instalation.")
# url = "https://code.visualstudio.com/download"
# r = s.get(url)

# soup = BeautifulSoup(r.text, "html.parser")
