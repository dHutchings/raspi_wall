#!/bin/bash

sudo ifconfig eth0 192.168.0.100 netmask 255.255.255.0
sudo route add -net 224.0.0.0 netmask 240.0.0.0 eth0
