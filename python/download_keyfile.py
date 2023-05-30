#!/usr/bin/env python3

import argparse
import sys

import util_functions


def main():
    parser = argparse.ArgumentParser(
        prog="Get Keyfile",
        description="Get Keyfile.",
    )

    parser.add_argument(
        "keyring",
        help="Keyring filename.",
    )

    parser.add_argument(
        "keyring_url",
        help="Keyring url.",
    )

    parser.add_argument(
        "type",
        choices=["dearmor", "wget", "wget_asc", "curl"],
        default="dearmor",
        help="Type of Keyring download.",
    )

    args = parser.parse_args()

    if args.type == "dearmor":
        ret_code, err = util_functions.gpg_dearmor(args.keyring, args.keyring_url)
    elif args.type == "wget":
        ret_code, err = util_functions.wget_gpg(args.keyring, args.keyring_url)
    elif args.type == "wget_asc":
        ret_code, err = util_functions.wget_asc(args.keyring, args.keyring_url)
    elif args.type == "curl":
        ret_code, err = util_functions.curl_gpg(args.keyring, args.keyring_url)

    if ret_code == 0:
        print(f"Could not add given keyring!\n{err}")
        sys.exit(ret_code)

    print(f"Added successfully!\n\tKeyring at: {args.keyring}.")


if __name__ == "__main__":
    util_functions.check_su()
    main()
