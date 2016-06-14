#!/bin/bash

#usage:
#./run_single_loop.sh -f PATH_TO_VIDEOS -l Location (1,2,3,4)

#start by parsing options, using the technique found on the stack overflow "How do I parse command line arguments in bash"
#Defaults
VIDEOPATH="."
echo $VIDEOPATH

LOCATION="" #currently, no location

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
		*)
			#unknown option
		;;
	esac
	shift
done
echo "PATH TO VIDEOS IS" $VIDEOPATH

function clean_up {
	#function to be called at the end, or on interrupt.
	/home/doug/Desktop/disp_case/control_computer/stop_single.sh -l $LOCATION
	echo "Exiting"
	exit
}

#magic line here that'll make it easier to ctrl-c out of this thing.
trap "clean_up" INT



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
			sleep .5
		fi

		#play video
		#-loglevel panic will cause the thing to display only serious errors.  Append the "location" variable to the IP.
		IP=udp://239.0.1.23:1234$LOCATION
		ffmpeg -loglevel panic -re -i $entry -vcodec copy -f avi -an $IP

	done

done

#shutdown all on close
clean_up()