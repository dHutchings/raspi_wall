#!/bin/bash

echo "start"

sshpass -p "raspberry" ssh pi@192.168.0.1 "sudo shutdown"
sshpass -p "raspberry" ssh pi@192.168.0.2 "sudo shutdown"
sshpass -p "raspberry" ssh pi@192.168.0.3 "sudo shutdown"
sshpass -p "raspberry" ssh pi@192.168.0.4 "sudo shutdown"


echo "done"