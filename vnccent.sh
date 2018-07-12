#!/bin/bash
################################################################################
#Set Colour Schemes
RED='\033[0;31m'
YLLO='\033[1;33m'
LCYAN='\033[1;36m'
LGRN='\033[1;32m'
NC='\033[0m' # No Color
cat <<"EOF"
################################################################################
Author: Saideep Kavidi
Github: https://github.com/sdkd-git/
License: MIT License
################################################################################
EOF
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

###########################################################################################

yum install tigervnc-server
read -p 'Enter the user you want to configure VNC:' uservar
echo -e "Provide password for VNC user min. 6 characters length."
sudo -u $uservar vncpasswd

cp /lib/systemd/system/vncserver@.service  /etc/systemd/system/vncserver@:1.service

cat > /etc/systemd/system/vncserver@\:1.service <<"EOF"
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target
[Service]
Type=forking
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/sbin/runuser -l $uservar -c "/usr/bin/vncserver %i -geometry 1280x1024"
PIDFile=/home/$uservar/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
[Install]
WantedBy=multi-user.target
EOF
echo -e 'Restarting Services'

systemctl daemon-reload

systemctl start vncserver@:1

systemctl status vncserver@:1

systemctl enable vncserver@:1

echo 'Bypassing ports in firewall'
firewall-cmd --add-port=5901/tcp
firewall-cmd --add-port=5901/tcp --permanent