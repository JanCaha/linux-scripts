#!/bin/bash

# Clear APT cache
sudo apt clean
sudo apt autoremove -y

# Other cache cleaners
conda clean --all --yes
pip cache purge
uv cache clean
rm -rf ~/.cache/gdb
rm -rf ~/.cache/vscode-cpptools/*
ccache --clear
  