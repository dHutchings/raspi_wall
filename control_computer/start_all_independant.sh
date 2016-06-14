#!/bin/bash

#will run untill ctrl-c'd.
#uses kill -TERM -$BASHPID (found on stack overflow) to kill all processies who's parent was this script.
trap "echo ENDING ; kill -TERM -$BASHPID" INT


./run_single_loop.sh -l 1 -p ../videos/top_left/ &
echo $!
./run_single_loop.sh -l 2 -p ../videos/top_right/ &
echo $!
./run_single_loop.sh -l 3 -p ../videos/bottom_left/ &
echo $!
./run_single_loop.sh -l 4 -p ../videos/bottom_right/ &
echo $!

while true
do
	:
done
#kill all processies started by this script on INT.