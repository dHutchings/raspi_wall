#!/bin/bash

VIDEOPATH="/home/doug/Desktop/disp_case/test_videos"



echo "start"
prev_width=-1
prev_height=-1
#while true; do

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
			/home/doug/Desktop/disp_case/control_computer/stop_all.sh > /dev/null
			/home/doug/Desktop/disp_case/control_computer/startup.sh > /dev/null
			sleep .5
		fi

		#play video
		#-loglevel panic will cause the thing to display only serious errors.
		ffmpeg -loglevel panic -re -i $entry -vcodec copy -f avi -an udp://239.0.1.23:1234
	done

#shutdown all on close
/home/doug/Desktop/disp_case/control_computer/stop_all.sh > /dev/null
echo "done"




#done
#sudo apt-get install libav-tools  for avconv