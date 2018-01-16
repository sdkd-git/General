#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

#if [ $SUDO_USER ]; then
#    real_user=$SUDO_USER
#else
#    real_user=$(whoami)
#fi
#Stop Nagios and Web Services
echo -e "Stopping Services"
systemctl stop nagios.service
systemctl stop  apache2.service
nagiosstat='systemctl status nagios.service'
echo "$nagiosstat"
#Download Latest Nagios Version
mv  /opt/ngdwn /tmp/ngdwn/
mkdir /opt/ngdwn
cd /opt/ngdwn
echo -e "Downloading Nagios Update"
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz
tar -xzvf nagios-4.3.4* >> /tmp/upgradeng.log
cd nagios-4.3.4*
echo "Installing the nagios"
./configure --with-command-group=nagcmd >> /tmp/upgradeng.log
make all >> /tmp/upgradeng.log
make install >> /tmp/upgradeng.log
make install-init >> /tmp/upgradeng.log
make install-commandmode >> /tmp/upgradeng.log
# make install-config >> /tmp/upgradeng.log
#Start Back Nagios Services
echo "Starting Services"
systemctl daemon-reload
systemctl restart nagios.service apache2.service
# check the errors in nagios configuration
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
echo "Installation Completed....!"
