#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

#Script for auto update/autoremove and dist-upgrade.

apt-get autoremove
apt-get update
apt-get dist-upgrade -y
