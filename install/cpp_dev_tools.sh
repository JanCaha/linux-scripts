#!/bin/bash
set -euo pipefail

# Install C++ development tools
sudo apt-get install -y \
    clang \
    lld \
    libclang-dev \
    ninja-build \
    doxygen \
    cmake \
    devscripts \
    libgtest-dev \
    libgmock-dev \
    libpqxx-dev \
    clang-format \
    google-perftools \
    valgrind \
    silversearcher-ag \
    expect \
    shellcheck \
    pre-commit \
    astyle \
    flip \
    ccache
