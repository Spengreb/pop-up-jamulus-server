#!/bin/bash -ex

# apt Deps
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt dist-upgrade -y
sudo apt-get install -y libqt5core5a libqt5network5 libqt5xml5
# Prometheus Setup
wget -O /tmp/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar xvzf /tmp/node_exporter.tar.gz -C /tmp/
sudo cp /tmp/node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
sudo mv /tmp/node_exporter.service /lib/systemd/system/

# Jamulus Setup
sudo useradd -m -s /bin/bash jam
wget -O /tmp/jamulus_headless_3.8.0_ubuntu_amd64.deb https://github.com/jamulussoftware/jamulus/releases/download/r3_8_0/jamulus_headless_3.8.0_ubuntu_amd64.deb
sudo dpkg -i /tmp/jamulus_headless_3.8.0_ubuntu_amd64.deb
sudo mv /tmp/jamulus.service /lib/systemd/system/
# Enable Services
sudo systemctl daemon-reload
sudo systemctl enable jamulus-headless.service
sudo systemctl enable node_exporter.service
