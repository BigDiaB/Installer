#!/bin/bash

HARDSET="6"
MAX=6

valuefile="/tmp/background_image_index.dat"

if [ -z $HARDSET ]; then
	if [ ! -f "$valuefile" ]; then
	        value=1
	else
	        value=$(cat "$valuefile")
	fi

	if [[ $# == 0 ]] ||  [[ ( $# == 1 && ( $1 == "set" || $1 == "reset" ) ) ]]; then

		if [[ $# == 1 && $1 == "set" ]]; then
			value=$(( $RANDOM % $MAX + 1 ))

			echo "${value}" > "$valuefile"
		fi

		feh --bg-fill ~/Bilder/BG/${value}.png
	else
		echo "~/Bilder/BG/${value}.png"
	fi
else
	if [[ $# == 0 ]] ||  [[ ( $# == 1 && ( $1 == "set" || $1 == "reset" ) ) ]]; then

		feh --bg-fill ~/Bilder/BG/${HARDSET}.png
	else
		echo "~/Bilder/BG/${HARDSET}.png"
	fi
fi
