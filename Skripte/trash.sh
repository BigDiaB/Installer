#!/bin/bash

TRASH_DIR=~/.trash
TRASH_MANIFEST=~/.trashinfo
TRASH_DURATION=604800

[ ! -d "$TRASH_DIR" ] && mkdir $TRASH_DIR
[ ! -f "$TRASH_MANIFEST" ] && touch $TRASH_MANIFEST

[ $# == 0 ] && exit

if [ $# == 1 ] && [[ $1 == "cleanup_trash" ]]; then
	FILE_COUNTER=1
	while read file; do
		TIME_STAMP=$(echo "$file" | awk -F"[][]" '{print $2}')
		
		if [ $(($TIME_STAMP)) -lt $(($(date +%s) - $TRASH_DURATION)) ]; then
			rm -rf $TRASH_DIR/$file
			echo "removing |$file|"
			sed -i "${FILE_COUNTER}d" $TRASH_MANIFEST
		else
			FILE_COUNTER=$(($FILE_COUNTER+1))
		fi

	done < $TRASH_MANIFEST
	exit
fi

for file in "$@"
do
	TIME_STAMP=$(date +%s)
	FILE_NAME=$(basename $file)
	echo "$FILE_NAME[$TIME_STAMP]" >> $TRASH_MANIFEST
	mv $file $TRASH_DIR/$FILE_NAME[$TIME_STAMP]
done
