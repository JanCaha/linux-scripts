FROM ubuntu:jammy

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common gnupg wget && \
    wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg  && \
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable  && \
    add-apt-repository ppa:ubuntugis/ppa && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntugis-nightly jammy main" > /etc/apt/sources.list.d/qgis.list && \
    apt update && \
    apt-get install -y python3-pip && \
    apt-get install -y qgis qgis-plugin-grass saga && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install debugpy

ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python