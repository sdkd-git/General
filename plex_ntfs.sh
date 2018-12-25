#!/bin/bash
#Command exits with a nonzero exit value
set -e
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
read -p "Enter a valid NTFS Path eg. /dev/sda1:  " path1
var1="$(blkid $path1 | grep 'ntfs' )"
if [[ $? > 0 ]]; then
  echo "Invalid  Path"
else
  cp /etc/fstab /etc/fstab$RANDOM.bak
  var2="$(blkid -s UUID -o value $path1)"
  mkdir $newdir
  echo "UUID=$var2 $newdir ntfs-3g fmask=000,dmask=000,uid=1000,gid=1000 0 0" > candy.log
fi