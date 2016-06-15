#!/bin/bash

#usage:
#./run_single_loop.sh -p PATH_TO_VIDEOS -l Location (1,2,3,4) -f status file name

#status file is a file with the number of times that the loop has executed.

#start by parsing options, using the technique found on the stack overflow "How do I parse command line arguments in bash"
#Defaults
VIDEOPATH="."
echo $VIDEOPATH

LOCATION="" #currently, no location

STATUS_FILE=""
LOOP_COUNT=0

while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-p| --path)
		VIDEOPATH="$2"
		shift
		;;
		-l| --location)
		LOCATION="$2"
		shift
		;;
		-f| --file)
		STATUS_FILE="$2".status
		echo $LOOP_COUNT > $STATUS_FILE 
		shift
		;;
		*)
			#unknown option
		;;
	esac
	shift
done
echo "PATH TO VIDEOS IS" $VIDEOPATH

function clean_up {
	#function to be called at the end, or on interrupt.
	#i need to Kill the ffmpeg process, since I can't wait for it to end...
	kill -TERM $FFMPEG_PROCESS
	/home/doug/Desktop/disp_case/control_computer/stop_single.sh -l $LOCATION
	echo "Exiting Shutdown of Monitor #" $LOCATION
	exit
}

#magic line here that'll make it easier to ctrl-c out of this thing.
trap "clean_up" TERM



prev_width=-1
prev_height=-1
while true; do

	for entry in $VIDEOPATH/*
	do
		echo $entry
		
		#ugly line.  Fist part gets all the parts of the movie, which is then searched for the line "height"
		#it will return two lines: height & coded height.  head -1 selects the first (height)
		#then, cut splits the string (height=XXX) by the delimiter "=", and loads the second value (XXX) to a varible
		height=$(ffprobe -v quiet -show_format -show_streams $entry | grep height | head -1 | cut -d "=" -f2)
		width=$(ffprobe -v quiet -show_format -show_streams $entry | grep width | head -1 | cut -d "=" -f2)
		
		if [ "$prev_width" -eq "$width" ] && [ "$prev_height" -eq "$height" ]; then
			echo "resolution ok"
			#do nothing.
		else

			echo "need to change resolution"
			echo "new resolution is Height" $height "width" $width
			prev_width=$width
			prev_height=$height
			/home/doug/Desktop/disp_case/control_computer/stop_single.sh -l $LOCATION > /dev/null
			/home/doug/Desktop/disp_case/control_computer/start_independant.sh -l $LOCATION > /dev/null
			sleep .25
		fi

		#play video
		#-loglevel panic will cause the thing to display only serious errors.  Append the "location" variable to the IP.
		IP=udp://239.0.1.23:1234$LOCATION
		ffmpeg -loglevel panic -re -i $entry -vcodec copy -f avi -an $IP &
		FFMPEG_PROCESS=$!
		wait $FFMPEG_PROCESS


	done
	#incriment loop_count variable
	LOOP_COUNT=$((LOOP_COUNT + 1))

	if [[ -n STATUS_FILE ]]; then #if the STATUS_FILE variable is NOT empty.
		#write my loop count to the file, for reference by outside processes.
		echo $LOOP_COUNT > $STATUS_FILE

	fi

done

#shutdown all on close
clean_up()