#!/bin/bash

echo "start"

sshpass -p "raspberry" ssh pi@192.168.0.1 "pkill pwomxplayer"
sshpass -p "raspberry" ssh pi@192.168.0.2 "pkill pwomxplayer"
sshpass -p "raspberry" ssh pi@192.168.0.3 "pkill pwomxplayer"
sshpass -p "raspberry" ssh pi@192.168.0.4 "pkill pwomxplayer"


echo "done"

#sudo apt-get install libav-tools  for avconv