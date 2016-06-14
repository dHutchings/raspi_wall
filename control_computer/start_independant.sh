#!/bin/bash



#usage

#./start_independant -l LOCATION


#Defaults
VIDEOPATH="."
echo $VIDEOPATH

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

echo "starting Monitor #"$LOCATION "Independantly"
IP=pi@192.168.0.$LOCATION

echo "IP IS " $IP
UDP=udp://239.0.1.23:1234$LOCATION

sshpass -p "raspberry" ssh $IP "sh -c 'nohup pwomxplayer --tile-code=11 "$UDP"?buffer_size=1200000B > /dev/null 2>&1 &'"

echo "done"

#sudo apt-get install libav-tools  for avconv