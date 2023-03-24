#!/bin/bash

xrandr --output eDP1 --auto --output DP2-2 --auto --right-of eDP1 --primary

bspc monitor DP2-2 -d 1 2 3
bspc monitor eDP1 -d 4 5
