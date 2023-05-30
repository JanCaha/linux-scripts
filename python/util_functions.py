import os
import sys
import subprocess
from typing import Tuple


class Colors:
    BLACK = "\033[30m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    PINK = "\033[35m"
    CYAN = "\033[36m"
    WHITE = "\033[37m"
    NORMAL = "\033[0;39m"


def ubuntu_name() -> str:
    result = subprocess.Popen(
        [
            "/bin/zsh",
            "-c",
            "source /etc/os-release;echo $UBUNTU_CODENAME",
        ],
        stdout=subprocess.PIPE,
    )

    name = result.stdout.readline().decode("utf-8").replace("\n", "")

    return name


def architecture() -> str:
    result = subprocess.Popen(
        [
            "/bin/zsh",
            "-c",
            "echo $(dpkg --print-architecture)",
        ],
        stdout=subprocess.PIPE,
    )

    return result.stdout.readline().decode("utf-8").replace("\n", "")


def check_su() -> None:
    if os.geteuid() != 0:
        print("Not a root, need sudo:")
        os.execvp("sudo", ["sudo", "python3"] + sys.argv)
    else:
        print("Already root.")


def is_true(value: str) -> bool:
    return value.lower().strip() == "true"


def add_key(key_file: str, fingerprint: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "gpg",
            "--no-default-keyring",
            "--keyring",
            key_file,
            "--keyserver",
            "hkp://keyserver.ubuntu.com:80",
            "--recv-keys",
            fingerprint,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    return return_code_and_err(result)


def create_source_file(
    filename: str,
    source_type: str,
    url: str,
    distro_code: str,
    component: str,
    keyring: str,
) -> None:
    with open(filename, "w+") as file:
        text = [
            f"Types: {source_type}",
            f"URIs: {url}",
            f"Suites: {distro_code}",
            f"Architectures: {architecture()}",
            f"Components: {component}",
            f"Signed-By: {keyring}",
        ]
        text = "\n".join(text)
        file.writelines(text)


def return_code_and_err(process: subprocess.Popen) -> Tuple[int, str]:
    err = process.stderr.readline().decode("utf-8").replace("\n", "")

    return (process.returncode, err)


def gpg_dearmor(filename: str, url: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "curl",
            "--fsSL",
            url,
            "|",
            "sudo",
            "gpg",
            "--dearmor",
            "-o",
            filename,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    return return_code_and_err(result)


def wget_gpg(filename: str, url: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "wget",
            "-O",
            filename,
            url,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    return return_code_and_err(result)


def wget_asc(filename: str, url: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "wget",
            "-qO-",
            url,
            "|",
            "sudo",
            "tee",
            "-a",
            filename,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    return return_code_and_err(result)


def curl_gpg(filename: str, url: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "curl",
            "-fsSL",
            url,
            "|",
            "sudo",
            "dd",
            f"of={filename}",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    return return_code_and_err(result)


# if __name__ == "__main__":
# check_su()