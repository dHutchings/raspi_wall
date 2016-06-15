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
possible_kill="" #possible kill, may need to reject based on names...

for line in "${array[@]}" ; do
	if [[ $count -eq '0' ]]; then
		#if this child's ID does NOT eq the parent id, or the ID of this own script.  Don't want to kill the script that's doing the killing....
		if [[ $line -ne $ID ]] && [[ $line -ne $BASHPID ]]; then
			#kill it.
			#echo "I may kill" $line
			possible_kill=$line

		fi
	elif [[ $count -eq '1' ]]; then
		: #we don't care about the parent's id
		#echo " 1 " $line
	elif [[ $count -eq '2' ]]; then\
		if [[ -n "$possible_kill" ]] && [[ $line == "run_single_loop" ]]; then
			#kill it.
			#echo "I will kill " $possible_kill $line

			kill -TERM $possible_kill
			#wait till it's actually dead to move on.
			wait $possible_kill

			#then reset possible kill
			possible_kill=""
		fi


	fi

	#make sure that count is properly handled...
	if [[ $count -eq '2' ]]; then
		count=0
	else
		count=$((count + 1))
	fi
done