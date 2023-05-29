from bs4 import BeautifulSoup
from bs4.element import Tag
import requests
import re
import subprocess
import sys

s = requests.Session()

url = 'https://freefilesync.org'
r = s.get(url + "/download.php")

soup = BeautifulSoup(r.text, "html.parser")

links = soup.findAll("a")

tar_link = None

link: Tag
version: str
file: str

for link in links:
    href = link.get("href")
    if isinstance(href, str):
        match = re.match("/download/FreeFileSync_.+_Linux.tar.gz", href)
        if match:
            tar_link = match.group(0)
            version = tar_link.split("_")[1]
            file = tar_link.replace("/download/", "")
            break

if version != sys.argv[2]:
    subprocess.run(["wget", url + tar_link])
    subprocess.run(["tar", "-xvf", file])
    unzipped = file.replace("Linux", "Install")
    unzipped = unzipped.replace("tar.gz", "run")
    print(unzipped)
    subprocess.run(["chmod", "+x", unzipped])
    subprocess.run(["sudo", f"./{unzipped}"])
    subprocess.run(["sed", "-i", f"s/^FreeFileSyncLastVersion=.*/FreeFileSyncLastVersion='{version}'/g", sys.argv[1]])
else:
    print("Skipping FreeFileSync instalation.")
