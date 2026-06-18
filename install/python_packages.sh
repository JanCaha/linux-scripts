#!/bin/bash
set -euo pipefail

# Install Python packages
sudo apt-get install -y \
    python3-pip \
    python3-pybind11 \
    python3-venv \
    python3-debugpy \
    python3-jupyter-core \
    python3-ipykernel \
    python3-nbclient \
    python3-flake8-black \
    python3-pycodestyle \
    python3-isort \
    python3-mypy \
    python3-selenium \
    python3-pytest \
    python3-pytest-cov \
    python3-pytestqt \
    pipx \
    python3-pip \
    python-is-python3 \
    python3-gdal

sudo apt-get install -y \
    python3-pyqt6 \
    python3-pyqt6.qsci \
    python3-pyqt6.qtbluetooth \
    python3-pyqt6.qtcharts \
    python3-pyqt6.qtdesigner \
    python3-pyqt6.qthelp \
    python3-pyqt6.qtmultimedia \
    python3-pyqt6.qtnfc \
    python3-pyqt6.qtpdf \
    python3-pyqt6.qtpositioning \
    python3-pyqt6.qtqml \
    python3-pyqt6.qtquick3d \
    python3-pyqt6.qtquick \
    python3-pyqt6.qtremoteobjects \
    python3-pyqt6.qtsensors \
    python3-pyqt6.qtserialport \
    python3-pyqt6.qtsvg \
    python3-pyqt6.qttexttospeech \
    python3-pyqt6.qtwebchannel \
    python3-pyqt6.qtwebengine \
    python3-pyqt6.qtwebsockets \
    python3-pyqt6.sip
