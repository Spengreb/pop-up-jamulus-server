#!/bin/bash -xe

sudo systemctl start jamulus-headless.service

sudo systemctl start node_exporter.service