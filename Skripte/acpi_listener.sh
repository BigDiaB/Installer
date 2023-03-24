#!/bin/bash

acpi_listen | while IFS= read -r event;
do
	echo "$event"
done
