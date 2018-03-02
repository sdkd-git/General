#!/bin/bash
################################################################################
#Set Colour Schemes
RED='\033[0;31m'
YLLO='\033[1;33m'
LCYAN='\033[1;36m'
LGRN='\033[1;32m'
NC='\033[0m' # No Color
#Variables
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
#
# host="$(hostname)"
# susr="$(printf '%s\n' "${SUDO_USER:-$USER}")"
# newdir="/media/$susr/$host$RANDOM"
# read -p "Enter a valid NTFS Path:" path1
# var1="$(blkid $path1 | grep 'ntfs' )"
# if [[ $? > 0 ]]; then
#   echo "Invalid  Path"
# else
#   cp /etc/fstab /etc/fstab$RANDOM.bak
#   var2="$(blkid -s UUID -o value $path1)"
#   mkdir $newdir
#   echo "UUID=$var2 $newdir ntfs-3g fmask=000,dmask=000,uid=1000,gid=1000 0 0" > candy.log
# fi
ost="$(hostname)"
susr="$(printf '%s\n' "${SUDO_USER:-$USER}")"
newdir="/media/$susr/$host$RANDOM"
read -p "Enter a valid NTFS Path:" path1
var1="$(blkid $path1 | grep 'ntfs' )"
if [[ $? > 0 ]]; then
  echo "Invalid  Path"
else
  cp /etc/fstab /etc/fstab$RANDOM.bak
  var2="$(blkid -s UUID -o value $path1)"
  mkdir $newdir
  echo "UUID=$var2 $newdir ntfs-3g fmask=000,dmask=000,uid=1000,gid=1000 0 0" > candy.log
fi
