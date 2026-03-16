#!/usr/bin/env python3

import runpy
import sys

import debugpy


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: run_pyqgis_test_debug.py <test_file>", file=sys.stderr)
        return 1

    test_file = sys.argv[1]

    debugpy.listen(("localhost", 5678))
    print("WAITING_FOR_DEBUGGER", flush=True)
    debugpy.wait_for_client()

    sys.argv = [test_file]
    runpy.run_path(test_file, run_name="__main__")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())