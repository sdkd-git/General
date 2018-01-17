#!/bin/bash
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

#Install Prerequisites
apt-get install apache2
a2enmod rewrite
a2enmod cgi
#Add User
echo "Adding nagios user"
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagios,nagcmd www-data

#Download Latest Nagios Version
mv  /opt/ngdwn /tmp/ngdwn/
mkdir /opt/ngdwn
cd /opt/ngdwn
echo -e "Downloading Nagios Update"
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz
tar -xzvf nagios-4.3.4* >> /tmp/upgradeng.log
cd nagios-4.3.4*
echo "Installing the nagios"
configdump="$(./configure --with-command-group=nagcmd)"
tail -n 5 $configdump
make all >> /tmp/upgradeng.log
make install >> /tmp/upgradeng.log
make install-init >> /tmp/upgradeng.log
make install-commandmode >> /tmp/upgradeng.log
make install-config >> /tmp/upgradeng.log
/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
# check the errors in nagios configuration
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
echo "Nagios installation Completed....!"
#Configure Nagios
mkdir -p /usr/local/nagios/etc/servers
#Start Back Nagios Services
echo "Starting Services"
systemctl daemon-reload
systemctl restart nagios.service apache2.service
#enable the Nagios virtualhost
ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
######################
# htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
