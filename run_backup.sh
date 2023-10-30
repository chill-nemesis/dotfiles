#!/bin/bash
DF_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

target_dir=$1
source_files=$2

if [ -z "$target_dir" ]; then
	echo "No destination provided! Aborting!"
	exit 10
fi

if [ ! -d "$target_dir" ]; then
	echo "Target is not a valid directory! Aborting!"
	exit 11
fi

if [ -z "$source_files" ]; then
	echo "No data to back up specified! Aborting!"
	exit 20
fi

if [ ! -f "$source_files" ]; then
	echo "Source list is not a valid file! Aborting!"
	exit 21
fi

while read -r line; do
	# skip lines starting with a '#' symbol - this allows comments
	[[ $line =~ ^#.* ]] && continue

	# echo "Backing up: $line to $target_dir"
	rsync -arR --delete $line $target_dir
done < <(grep . $source_files)
# Note: We need to use the grep-hack to avoid ignoring the last entry
# and to skip possibly empty lines
# see here: https://stackoverflow.com/questions/16627578/bash-iterating-through-txt-file-lines-cant-read-last-line