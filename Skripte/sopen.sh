#!/bin/bash

if [[ $# == 0 ]]; then
	exit
else
	for file in "$@"
	do
		xdg-open $file & disown
	done
fi
