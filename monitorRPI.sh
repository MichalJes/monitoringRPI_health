#!/bin/sh
stty -echoctl
clear
tput civis
temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
clock=$(vcgencmd measure_clock arm | awk ' BEGIN { FS="=" } ; { print $2 / 1000000000} ')
voltage=$(vcgencmd measure_volts core | egrep -o '[0-9]*\.[0-9]*')
hex=$(vcgencmd get_throttled | awk ' BEGIN { FS="=0x" } ; { print $2}')
bin=$(echo "obase=2; ibase=16; $hex" | bc)
zero=$0
echo "RPI core information:"
echo "-> Temperature:    $temp [C]"
echo "-> Clock speed:    $clock [GHz]"
echo "-> Clock voltage:  $voltage [V]"
echo "-> Throttle error: $bin [b]"
echo "== Press Ctr+C to exit =="
tput sc
while :; do
	unset ctrl_c
	trap 'ctrl_c=3Dtrue' INT
	temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuf 19
	echo $temp
	tput rc
	clock=$(vcgencmd measure_clock arm | awk ' BEGIN { FS="=" } ; { print $2 / 1000000000} ')
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuf 19
	echo $clock
	tput rc
	voltage=$(vcgencmd measure_volts core | egrep -o '[0-9]*\.[0-9]*')
	tput cuu1
	tput cuu1
	tput cuu1
	tput cuf 19
	echo $voltage
	tput rc
	hex=$(vcgencmd get_throttled | awk ' BEGIN { FS="=0x" } ; { print $2}')
	bin=$(echo "obase=2; ibase=16; $hex" | bc)
	tput cuu1
	tput cuu1
	tput cuf 19
	tput rc
	sleep 0.5
	trap - INT
	if [ $ctrl_c ]; then
		tput cvvis
		clear
		exit
	fi
done
