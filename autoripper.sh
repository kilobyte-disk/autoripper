#!/bin/bash

# kilobyte_disk 2025
# autoripper.sh
#
# Purpose:
# a script to automatically rip CDs when
# they are inserted into drives.


CDROM_PREFIX=/dev/sr

drives=()

echo "Welcome to autoripper,"
echo "the jankiest auto cd ripper around."
echo

if [[ ! -f "./programs/drivestatus" ]]; then
	echo "Missing executable ./programs/drivestatus"
	echo "Please compile it from ./programs/drivestatus.c"
	exit
fi

echo "Initializing drivelist... Scanning $CDROM_PREFIX*"
for drive in $CDROM_PREFIX*; do
	if [[ $drive = "$CDROM_PREFIX*" ]]; then
		echo "ERROR: Unable to find any drives."
		exit
	fi

	echo "$drive"
	drives+=(0)
done
echo

echo "Checking for output dir..."
if [[ ! -d "$HOME/abcde_out" ]]; then
	echo "Creating output directory... ~/abcde_out/"
	mkdir $HOME/abcde_out
fi

echo "Checking for abcde and flac..."
abcde_cmd=abcde
flac_cmd=flac

if [[ ! $(type -P "$abcde_cmd") ]]; then
	echo "abcde is NOT on the PATH! Please install abcde or define it if it exists."
	exit
fi

if [[ ! $(type -P "$flac_cmd") ]]; then
	echo "flac is NOT on the PATH. Please install flac or define it if it exists."
	exit
fi




sleep 3

function makebar()
{
	echo "============================"
}

function showdiv()
{
	echo "++++++++++++++++++++++++++++"
}


function refresh_screen()
{
	clear
	makebar
	echo "        autoripper v1"
	echo
	echo " files output: ~/abcde_out/"
	makebar
	echo
	echo
}


while true; do
	refresh_screen

	i=-1
	for drive in $CDROM_PREFIX*; do
		((i++))
		
		echo && echo
		makebar

		echo "Checking "$drive"..."
		status=$(./programs/drivestatus "$drive")

		# Logic
		if [[ "$status" -eq 2 ]]; then
			echo "OPEN, READY"

			# abcde opens the tray when it finishes,
			# unmark the drive and be ready for next disc.
			drives[$i]=0
			continue
		fi


		# Messages
		if [[ ${drives[$i]} -eq 1 ]]; then
			echo "abcde IN PROGRESS..."
	
			showdiv

			if [ -f ./abcde_$i.log ]; then
				tail ./abcde_$i.log
			fi
			
			showdiv
			echo

			continue
		fi

		if [[ "$status" -lt 0 ]]; then
			echo "ERROR"
			continue
		fi

		if [[ "$status" -eq 1 ]]; then
			echo "READY"
			continue
		fi

		if [[ "$status" -eq 3 ]]; then
			echo "DRIVE NOT READY"
			continue
		fi

		# Logic
		if [[ "$status" -eq 4 ]]; then
			echo "STARTING abcde..."

			drives[$i]=1

			(abcde -B -G -d "$drive" &) &>> ./abcde_$i.log
		fi
	done

	
	echo
	echo
	echo "Press (q) to quit"

	read -t 1 -N 1 input
	if [[ "$input" = "q" ]] || [[ "$input" = "Q" ]]; then
		echo
		echo "Quitting..."

		kill $(jobs -p)
		break
	fi
done

echo

for file in ./abcde_*.log; do
	echo

	read -N 1 -p "Delete log file ${file} ? (y/N): " input
	if [[ "$input" = "y" ]]; then
		echo
		echo "Deleting..."
		rm "$file"
	fi
done

echo
