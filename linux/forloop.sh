#!/bin/bash

set pipefail -euxo

# For loop oneliner to delete a list of apt packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
