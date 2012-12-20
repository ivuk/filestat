#!/bin/bash
# vim: ts=2

# Get the list of files in the target folder
GetListOfFiles()
{
# Check if the target directory exists
# And that it is not a symlink
# Otherwise exit
if [[ -d "$1" && ! -L "$1" ]]; then
# Get list of elements in target directory
	ArrayOfFiles=($(echo "$1/*"))
else
	echo "$1 does not exist or is not a directory."
	exit 14
fi
}

GetFilesData()
{
declare -A ArrayOfFilesInfo
for elem in "${ArrayOfFiles[@]}"; do
	ArrayOfFilesInfo=(["$elem"]=$(file "$elem"))
# FIXME - I have no idea why this works
	echo "${ArrayOfFilesInfo[@]/%/$'\n'}" | column
done
}

# Parse command line options
while getopts ":ahvd:" option; do
	case $option in
		a)
			echo '-a triggered'
			;;
		d)
			GetListOfFiles "$OPTARG"
			GetFilesData
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
