#!/bin/bash

ID=''

while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-i | --id)
		ID="$2"
		shift
		;;
		*)
			#unknown option
		;;
	esac
	shift
done

#make sure that I got an ID to kill....
if [[ -z "$ID" ]]; then
	echo "BAD USAGE"
	exit
fi

#the tr line replaces \n's with spaces
#xargs trims leading/training whitespace
text=$(ps x -o "%p %r %c" | grep $ID | tr '\n' ' ' | xargs) 
#replace spaces with commas
text=${text// /,}
echo $text
#lines is now a massive, comma-septerated, string.  If the first ID is the process ID, second is the Parent Group ID, and third is the name

IFS=',' read -r -a array <<< "$text"

echo $array

count=0 #count because of the triple-nature of this loop, i need to keep track...

array_to_kill=()

for line in "${array[@]}" ; do
	if [[ $count -eq '0' ]]; then
		#if this child's ID does NOT eq the parent id
		if [[ $line -ne $ID ]]; then
			#kill it.
			echo "killing" $line
			kill -TERM $line
		fi
	elif [[ $count -eq '1' ]]; then
		: #we don't care about the parent's id
		#echo " 1 " $line
	elif [[ $count -eq '2' ]]; then
		: #we don't care about the names...
		#echo " 2 " $line
	fi

	#make sure that count is properly handled...
	if [[ $count -eq '2' ]]; then
		count=0
	else
		count=$((count + 1))
	fi
done

echo "There are now" $(grep $ID | wc -l) "processes from the parent... should be only 1"