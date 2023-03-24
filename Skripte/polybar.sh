#!/bin/bash

killall -q polybar

polybar -c ~/conf/polybar.conf example & disown
