#!/bin/bash

conda clean --all --yes
pip cache purge
uv cache clean
rm -rf ~/.cache/gdb
rm -rf ~/.cache/vscode-cpptools/*  