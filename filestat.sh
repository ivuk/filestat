#!/bin/bash
# vim: ts=2

# Get the list of files in the target folder
GetListOfFiles()
{
# Check if the target directory exists
# And that it is not a symlink
# Otherwise exit
if [[ -d "$1" && ! -L "$1" ]]; then
# List only files, ignore other things
	ArrayOfFiles=($(ls -l "$1" | awk '/^-/ {print $NF}'))
#	for elem in ${!ArrayOfFiles[*]}; do
#		printf "%s\n" ${ArrayOfFiles[$elem]}
#		printf "%4d: %s\n" $elem ${ArrayOfFiles[$elem]}
#	done
else
	echo "$1 does not exist or is not a directory."
	exit 14
fi
# Prepend the required directory
NewArrayOfFiles=("${ArrayOfFiles[@]/#/$1/}")

# Get some serious work done
GetFilesData "${NewArrayOfFiles[@]}"
}

GetFilesData()
{
declare -A ArrayOfFilesInfo
for i in "${NewArrayOfFiles[@]}"; do
	ArrayOfFilesInfo=(["$i"]=$(file "$i"))
#	for elem in ${!ArrayOfFilesInfo[*]}; do
#		printf "%s\n" ${ArrayOfFilesInfo[$elem]}
#	done
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
