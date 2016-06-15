#!/bin/bash

#usage
#./start_independant -l LOCATION

#Defaults
LOCATION="" #currently, no location

while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-l| --location)
		LOCATION="$2"
		shift
		;;
		*)
			#unknown option
		;;
	esac
	shift
done

echo "stopping Monitor #"$LOCATION "Independantly"
IP=pi@192.168.0.$LOCATION
sshpass -p "raspberry" ssh $IP "pkill pwomxplayer"

#sudo apt-get install libav-tools  for avconv