#!/bin/bash

#Script for auto update/autoremove and dist-upgrade.

apt-get autoremove
apt-get update
apt-get dist-upgrade -y