#!/bin/bash
valuefile="/tmp/screen_rotation.dat"

internal="eDP1"


finger="'Wacom Pen and multitouch sensor Finger touch'"
stylus="'Wacom Pen and multitouch sensor Pen stylus'"
eraser="'Wacom Pen and multitouch sensor Pen eraser'"

#IDs instead of device-names
finger='9'
stylus='10'
eraser='16'

if [ ! -f "$valuefile" ]; then
	value=0
else
	value=$(cat "$valuefile")
fi
value=$((value + 1))

if [ $# == 1 ]; then
	value=$1
fi

if [ $value -ge 4 ]; then
	value=0
fi
echo "${value}" > "$valuefile"

if [ $value -eq 0 ] ; then
	xrandr --output $internal --rotate normal
	xsetwacom set $stylus rotate none
	xsetwacom set $finger rotate none
	xsetwacom set $eraser rotate none
elif [ $value -eq 1 ] ; then
	xrandr --output $internal --rotate left
	xsetwacom set $stylus rotate ccw
	xsetwacom set $finger rotate ccw
	xsetwacom set $eraser rotate ccw
elif [ $value -eq 2 ] ; then
	xrandr --output $internal --rotate inverted
	xsetwacom set $stylus rotate half
	xsetwacom set $finger rotate half
	xsetwacom set $eraser rotate half
elif [ $value -eq 3 ] ; then
	xrandr --output $internal --rotate right
	xsetwacom set $stylus rotate cw
	xsetwacom set $finger rotate cw
	xsetwacom set $eraser rotate cw
fi

~/Skripte/wallpaper.sh reset

xsetwacom set $stylus MapToOutput $internal
xsetwacom set $eraser MapToOutput $internal
xsetwacom set $finger  MapToOutput $internal
