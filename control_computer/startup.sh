#!/bin/bash

echo "start"

#note: need to have ssh'd into the machine at least once before... because:
#The authenticity of host '192.168.0.3 (192.168.0.3)' can't be established.
#ECDSA key fingerprint is ba:70:f4:95:82:54:96:9f:30:2c:cf:da:68:c4:f5:8a.
#Are you sure you want to continue connecting (yes/no)? yes
#Warning: Permanently added '192.168.0.3' (ECDSA) to the list of known hosts.

#sudo add-apt-repository ppa:mc3man/trusty-media
#sudo apt-get update
#sudo apt-get install ffmpeg


sshpass -p "raspberry" ssh pi@192.168.0.1 "sh -c 'nohup pwomxplayer --tile-code=41 udp://239.0.1.23:1234?buffer_size=1200000B > /dev/null 2>&1 &'"
sshpass -p "raspberry" ssh pi@192.168.0.2 "sh -c 'nohup pwomxplayer --tile-code=42 udp://239.0.1.23:1234?buffer_size=1200000B > /dev/null 2>&1 &'"
sshpass -p "raspberry" ssh pi@192.168.0.3 "sh -c 'nohup pwomxplayer --tile-code=43 udp://239.0.1.23:1234?buffer_size=1200000B > /dev/null 2>&1 &'"
sshpass -p "raspberry" ssh pi@192.168.0.4 "sh -c 'nohup pwomxplayer --tile-code=44 udp://239.0.1.23:1234?buffer_size=1200000B > /dev/null 2>&1 &'"


echo "done"

#sudo apt-get install libav-tools  for avconv