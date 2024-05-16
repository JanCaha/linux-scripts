import os
import subprocess
import sys
from pathlib import Path
from typing import Optional, TextIO, Tuple


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


def print_error(text: str) -> None:
    print_color_output(text, Colors.RED, sys.stderr)


def print_success(text: str) -> None:
    print_color_output(text, Colors.GREEN, sys.stdout)


def print_info(text: str) -> None:
    print_color_output(text, Colors.YELLOW, sys.stdout)


def print_skip(text: str) -> None:
    print_color_output(text, Colors.PINK, sys.stdout)


def print_color_output(
    text: str,
    color: str = Colors.RED,
    output: TextIO = sys.stdout,
) -> None:
    print(color + text + Colors.NORMAL, file=output)


def install_variables_file() -> Path:
    return Path().home() / ".install_env_variables"


def variables_file_exist():
    return install_variables_file().exists()


def get_install_variable(name: str) -> Optional[str]:
    if variables_file_exist():
        result = subprocess.Popen(
            [
                "/bin/zsh",
                "-c",
                f"source {install_variables_file().as_posix()};echo ${name}",
            ],
            stdout=subprocess.PIPE,
        )

        std_out = result.stdout
        if std_out:
            name = std_out.readline().decode("utf-8").replace("\n", "")

            if name:
                return name

    return None


def binary_exist(name: str) -> bool:
    result = subprocess.Popen(
        [
            "whereis",
            name,
        ],
        stdout=subprocess.PIPE,
    )

    std_out = result.stdout
    if std_out:
        text = std_out.readline().decode("utf-8").replace("\n", "").split(":")
    else:
        text = ["", ""]

    if text[1]:
        return True
    return False


def ubuntu_name() -> str:
    result = subprocess.Popen(
        [
            "/bin/zsh",
            "-c",
            "source /etc/os-release;echo $UBUNTU_CODENAME",
        ],
        stdout=subprocess.PIPE,
    )

    std_out = result.stdout
    if std_out:
        name = std_out.readline().decode("utf-8").replace("\n", "")
    else:
        name = ""

    return name


def get_architecture() -> str:
    result = subprocess.Popen(
        [
            "/bin/bash",
            "-c",
            "echo $(dpkg --print-architecture)",
        ],
        stdout=subprocess.PIPE,
    )
    std_out = result.stdout
    if std_out:
        name = std_out.readline().decode("utf-8").replace("\n", "")
    else:
        name = ""

    return name


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
    architecture: Optional[str] = None,
) -> None:
    if architecture is None:
        architecture = get_architecture()

    with open(filename, "w+", encoding="utf-8") as file:
        lines = [
            f"Types: {source_type}",
            f"URIs: {url}",
            f"Suites: {distro_code}",
            f"Architectures: {architecture}",
            f"Components: {component}",
            f"Signed-By: {keyring}",
        ]
        text = "\n".join(lines)
        file.writelines(text)


def return_code_and_err(process: subprocess.Popen) -> Tuple[int, str]:
    std_out = process.stdout
    if std_out:
        err = std_out.readline().decode("utf-8").replace("\n", "")
    else:
        err = ""

    return (process.returncode, err)


def is_success(process: subprocess.Popen) -> bool:
    return process.returncode == 0


def check_dearmor(filename: Path) -> bool:
    content = filename.read_text()
    return "BEGIN PGP PUBLIC KEY BLOCK" in content and "END PGP PUBLIC KEY BLOCK" in content


def wget(filename: str, url: str) -> Tuple[int, str]:
    commands = [
        "sudo",
        "wget",
        "-O",
        filename,
        "-q",
        url,
    ]
    result = subprocess.Popen(
        commands,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    result.wait()

    return return_code_and_err(result)


def curl(filename: str, url: str) -> Tuple[int, str]:
    result = subprocess.Popen(
        [
            "sudo",
            "curl",
            "-fsSL",
            url,
            "--output",
            filename,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    result.wait()

    return return_code_and_err(result)


# if __name__ == "__main__":
# check_su()
