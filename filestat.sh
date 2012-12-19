#!/bin/bash
# vim: ts=2

# Get the list of files in the target folder
GetListOfFiles()
{
# Check if the target directory exists
# If it does not, exit
# If it is a symlink, exit
# Otherwise, all is well, list all the files in it
if [ ! -d "$1" ]; then
	echo "Directory $1 does not exist."
	exit 14
elif [ -L "$1" ]; then
	echo "Directory $1 is a symlink."
	exit 14
else
	List=$(ls -1 "$1")
	echo "$List"
fi
}

#GetFilesData

# Parse command line options
while getopts ":ahvd:" option; do
	case $option in
		a)
			echo '-a triggered'
			;;
		d)
###			echo "-d was triggered, Parameter: $OPTARG"
			GetListOfFiles "$OPTARG"
			;;
		h)
			echo 'Available command line switches are : -a -d <dir> -h -v'
			;;
		v)
			echo 'Version 0.1 "What do we have here?"'
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 14
			;;
		\?)
			echo "Invalid option : -$OPTARG"
			;;
	esac
done
