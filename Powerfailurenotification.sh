#!/bin/bash
acpower="/sys/class/power_supply/AC/online"
old= "$(cat $acpower)"
while sleep 1; do
	new="$(cat $acpower)"
	if [[ "$new" != "$old" ]]; then
		if [[ "new" == "1"]]; then
			notify-send --icon=gnome-power-manager "AC Mode"
		elif [[ "new" == "0" ]]; then
			notify-send --icon=gnome-power-manager "Battery Mode"
		fi
	fi
	old="$new"
done