#!/bin/bash
#PS4='$(date "+%s.%N ($LINENO) + ")'

set -euo pipefail

# Reset ouput verbosity
VerbositySet=0

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
# Declare an associative array
# Stick the needed data into it
declare -A ArrayOfFilesInfo
for elem in "${ArrayOfFiles[@]}"; do
	ArrayOfFilesInfo+=(["$elem"]=$(file -b "$elem"))
done

# Show the total number of files
echo "Total number of files in the target folder: ${#ArrayOfFilesInfo[@]}"

# Check if verbose is set by passing -a argument
# If it is, print the filenames
# Else print the number of elements by type
if [ "$VerbositySet" -eq 1 ]; then
#	printf '%s|%s\n' "${!ArrayOfFilesInfo[@]}" "${ArrayOfFilesInfo[@]}" | column -t -s '|'
	for elem in "${!ArrayOfFilesInfo[@]}"; do
		echo "$elem%${ArrayOfFilesInfo[$elem]}"
	done | column -t -s '%'
else
# FIXME - is it better to use printf or just for?
	printf "%s\n" "${ArrayOfFilesInfo[@]}" | sort | uniq -c
#	for elem in "${!ArrayOfFilesInfo[@]}"; do
#		echo "${ArrayOfFilesInfo[$elem]}"
#	done | sort | uniq -c
fi
}

# Parse command line options
while getopts ":ahvd:" option; do
	case $option in
		a)
			VerbositySet=1
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
