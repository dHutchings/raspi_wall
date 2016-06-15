#!/bin/bash

#will run untill ctrl-c'd.
#uses kill -TERM -$BASHPID (found on stack overflow) to kill all processies who's parent was this script.
trap "echo ENDING ; rm *.status ; kill -TERM -$BASHPID" INT


./run_single_loop.sh -l 1 -p ../videos/top_left/ -f 1 &
echo $!
./run_single_loop.sh -l 2 -p ../videos/top_right/ -f 2 &
echo $!
./run_single_loop.sh -l 3 -p ../videos/bottom_left/ -f 3 &
echo $!
./run_single_loop.sh -l 4 -p ../videos/bottom_right/ -f 4 &
echo $!

while true
do
	:
done
#kill all processies started by this script on INT.