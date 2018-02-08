#!/bin/bash
################################################################################
#Set Colour Schemes
RED='\033[0;31m'
YLLO='\033[1;33m'
LCYAN='\033[1;36m'
LGRN='\033[1;32m'
NC='\033[0m' # No Color
#Variables
installpkg='ansible git'
################################################################################
cat <<"EOF"
                           (   (        ) (
                           )\ ))\ )  ( /( )\ )
                          (()/(()/(  )\()|()/(
                           /(_))(_))((_)\ /(_))
                          (_))(_))_|_ ((_|_))_
                          / __||   \ |/ / |   \
                          \__ \| |) |" <  | |) |
                          |___/|___/_|\_\ |___/
################################################################################
Author: Saideep Kavidi
Github: https://github.com/sdkd-git/
License: MIT License
################################################################################
EOF
################################################################################
#Command exits with a nonzero exit value
set -e
#Check is user is running with permission
if ! [ $(id -u) = 0 ]; then
  echo -e "\n${YLLO}The script need to be run as root.${NC}" >&2
  exit 1
fi
#Generate Log File
logfile='/tmp/postinstall.log'
echo -e "\n \n \n \n$(date)\n$(uname -nir)\n" >> $logfile
#check for internet connectivity
echo -e "${LCYAN}Checking internet connectivity\n${NC}"
pngint="$(ping 8.8.8.8 -c 1 -W 4 -q)"
if [ $? -eq 0 ];
then
  echo -e "${LGRN}Connected to internet.\n${NC}"
else
  echo -e "${RED}Could not connect to internet. Stopping further actions..!\n${NC}" >&2
  exit 2
fi
dnsping="$(ping google.com -c 1 -W 4 -q)"
if ! [ $? = 0 ];
then
  echo -e "${RED}Could not resolve DNS. Stopping further actions..!\n${NC}" >&2
  exit 3
fi
echo -e "${LGRN}Adding mongo Key${NC}"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo -e "${LGRN}Adding mongodb to repo list${NC}"
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# 3. Update the list of available packages
apt-get update
#
apt-get install apache2 mongodb-org php5 php5-dev libapache2-mod-php5 php5-curl php5-gd apache2-threaded-dev build-essential php-pear
systemctl start mongod
systemctl enable mongodb
ufw allow 27017
ufw status
