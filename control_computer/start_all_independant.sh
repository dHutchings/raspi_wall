#!/bin/bash

#will run untill ctrl-c'd.
#uses kill -TERM -$BASHPID (found on stack overflow) to kill all processies who's parent was this script.
trap "echo ENDING ; rm *.status ; kill -TERM -$BASHPID" INT

echo "My PID is" $BASHPID

./run_single_loop.sh -l 1 -p ../videos/top_left/ -f 1 &
./run_single_loop.sh -l 2 -p ../videos/top_right/ -f 2 &
./run_single_loop.sh -l 3 -p ../videos/bottom_left/ -f 3 &
./run_single_loop.sh -l 4 -p ../videos/bottom_right/ -f 4 &


#start to read status files, to see if I've looped through all the videos at least once.
declare -a all_status_files=("1.status" "2.status" "3.status" "4.status")
#have I finished my first run?
first_run_over=0


while [ "$first_run_over" -eq "0" ]
do
	done_with_all=1
	for i in "${all_status_files[@]}"; do
		if [[ $(cat $i) -eq 0 ]]; then
			done_with_all=0
		fi

	done

	if [[ done_with_all -eq 1 ]]; then
		first_run_over=1
	fi

	sleep .5
done


echo "Done with all first runs"


./kill_children_of.sh -i $BASHPID

echo "Killed all the kids!"

#sends ctrl-z siginal to itself, which also gets the nice erasure of status files.
kill -INT -$BASHPID