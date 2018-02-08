#!/bin/bash
#Check is user is running with permission
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" >> /etc/apt/sources.list
# 3. Update the list of available packages
sudo apt-get update
#
sudo apt-get install apache2 mongodb-10gen php5 php5-dev libapache2-mod-php5 php5-curl php5-gd apache2-threaded-dev build-essential php-pear
