#!/bin/bash

#usage ./run_all_loop -p PATH -l #of loops -f for a "Forever"
VIDEOPATH=""
LOOP_COUNT=0
FOREVER=false
FFMPEG_PROCESS=""
while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-p | --path)
		VIDEOPATH="$2"
		shift
		;;
		-l | --loop)
		LOOP_COUNT="$2"
		shift
		;;
		-f | --forever)
		FOREVER=true
		shift
		;;
		*)
			#unknown option
		;;
	esac
	shift
done


function clean_up {
	#function to be called at the end, or on interrupt.
	#i need to Kill the ffmpeg process, since I can't wait for it to end...
	kill -TERM $FFMPEG_PROCESS
	/home/doug/Desktop/disp_case/control_computer/stop_all.sh > /dev/null
	echo "Shutdown all monitors"
	exit
}

#magic line here that'll make it easier to ctrl-c out of this thing.
trap "clean_up" TERM

echo "start"
prev_width=-1
prev_height=-1
while $FOREVER || [[ $LOOP_COUNT -gt "0" ]]; do
	#echo $FOREVER
	#echo $LOOP_COUNT
	for entry in $VIDEOPATH/*
	do
		echo $entry
		#ugly line.  Fist part gets all the parts of the movie, which is then searched for the line "height"
		#it will return two lines: height & coded height.  head -1 selects the first (height)
		#then, cut splits the string (height=XXX) by the delimiter "=", and loads the second value (XXX) to a varible
		height=$(ffprobe -v quiet -show_format -show_streams $entry | grep height | head -1 | cut -d "=" -f2)
		width=$(ffprobe -v quiet -show_format -show_streams $entry | grep width | head -1 | cut -d "=" -f2)
		
		if [ "$prev_width" -eq "$width" ] && [ "$prev_height" -eq "$height" ]; then
			:
			#echo "resolution ok"
			#do nothing.
		else

			#echo "need to change resolution"
			echo "new resolution is Height" $height "width" $width
			prev_width=$width
			prev_height=$height
			/home/doug/Desktop/disp_case/control_computer/stop_all.sh > /dev/null
			/home/doug/Desktop/disp_case/control_computer/startup.sh > /dev/null
			sleep .5
		fi

		#play video
		#-loglevel panic will cause the thing to display only serious errors.
		#dO this complicated buisness so ./run_all_loop.sh exits very cleanly using the 'cleanup function'
		ffmpeg -loglevel panic -re -i $entry -vcodec copy -f avi -an udp://239.0.1.23:1234 &
		FFMPEG_PROCESS=$!
		wait $FFMPEG_PROCESS
		echo "show video"
	done
	LOOP_COUNT=$((LOOP_COUNT - 1))

done

#shutdown all on close
clean_up
