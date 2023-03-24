#!/bin/bash

MODE_MIRROR="mirror"
MODE_REPLACE="extern"

DEFAULT_MODE=$MODE_MIRROR

mode="unknown"
internal="eDP1"
external="unknown"

CHECK_EXIT="false"

if [ -z $(command -v awk) ]; then
	echo "'awk' not in PATH!"
	CHECK_EXIT="true"
fi

if [ -z $(command -v sed) ]; then
	echo "'sed' not in PATH!"
	CHECK_EXIT="true"
fi

if [ -z $(command -v grep) ]; then
	echo "'grep' not in PATH!"
	CHECK_EXIT="true"
fi

if [ -z $(command -v xrandr) ]; then
	echo "'xrandr' not in PATH!"
	CHECK_EXIT="true"
fi

if [ $CHECK_EXIT == "true" ]; then
	echo "One or more crucial programs not in PATH. exiting"
	exit
fi 

if [ $# == 1 ]; then
	if [ $1 == $MODE_MIRROR ] || [ $1 == $MODE_REPLACE ]; then
		mode="$1"
		echo "No monitor was specified. Trying to find a suitable monitor.."
		external=$(xrandr | grep " connected" | awk '{print $1}' | sed s/$internal// | awk '{print $1}')
		
		external=${external//$'\n'/}
	
		if [[ -z $external ]]; then
			echo "Couldn't find external monitor. Exiting.."
			exit
		fi

		echo "Found external monitor '$external'"
	else
		external="$1"
		echo "Defaulting to Mode '$MODE_MIRROR'"
		mode=$MODE_MIRROR
	fi
elif [ $# == 2 ]; then
	if [ $1 == $MODE_MIRROR ] || [ $1 == $MODE_REPLACE ]; then
             	external="$2"
		mode="$1"
	else
		external="$1"
		mode="$2"
	fi
elif [ $# == 0 ]; then
	echo "Nothing was specified. Trying to find a suitable monitor.."
	
	external=$(xrandr | grep " connected" | awk '{print $1}' | sed s/$internal// | awk '{print $1}')

        external=${external//$'\n'/}

        if [ -z $external ]; then
                echo "Couldn't find external monitor. Exiting.."
                exit
        fi

	echo "Found external monitor '$external'"
	
	mode=$DEFAULT_MODE

	echo "Defaulting mode to '$mode'"
else
	echo "Invalid number of args given. Exiting.."
	exit
fi

echo "Using Display '$external' in mode '$mode'"

res="$(xrandr | grep $external)"
if [ -z "$res" ]; then
	echo "Display '${external}' doesn't exist. Exiting.."
	exit
elif [ $(echo "$res" | awk '{ print $2 }') == "disconnected" ]; then
	echo "Display '${external}' isn't connected. Exiting.."
	exit
elif [ $external == $internal ]; then
        echo "You passed the integrated display '$internal' as an argument. Resetting integrated display and exiting.."
        echo "Resetting display ${integrated}s settings using --auto.."
        xrandr --output $internal --auto
       	exit
fi

if [ $mode == $MODE_REPLACE ]; then
	echo "Set mode to '$mode'.. disabling integrated display '$internal'"
	xrandr --output $internal --off --output $external --auto --primary
else
	echo "Getting display '$internal's resolution.."
	res="$(xrandr | grep "$internal"  | grep -oP '\d+x\d+')"

	if [ -z $res ]; then
		echo "Intergrated display '$internal' probably disabled using 'xrandr --off'. Restoring using 'xrandr --auto'"
		xrandr --output $internal --auto
		res="$(xrandr | grep "$internal"  | grep -oP '\d+x\d+')"
	fi

	echo "Display '$internal's current and display '$external's future resolution is $res"
	xrandr --output $external  --same-as $internal --mode $res
fi

Skripte/wallpaper.sh reset
