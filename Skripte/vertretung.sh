#!/bin/bash
: '
* Author: 		Benjamin Emde
* Version:		4.1.2
* Last edit:		22.03.2023
* Description:
*	Ein kurzes Skript, das ein Dokument eines
*	Webservers herunterlädt und ggf. nach
*	Informationen filtert und dann in stdout
*	oder als html-Datei ausgibt und in einem Programm öffnet.
*
*	Die benutzen Funktionen sind:
*		- cURL
*		- poppler-utils
*		- unix-gnu-grep
*		- sed
*		- awk
*
*	Mögliche Bugs:
*		- File-Access in /tmp
*		- weder OSX noch xdg-open noch gnome-open in manchen Systemen?
*
*	Todos:
*		- Graphisches Front-End in SDL2 oder komplett in HTML+CSS+JS
*		- Kompletter Rewrite in Lua o.Ä. für Windows-Kompatiblität
'



FETCH_DEST="/tmp/vertretungsplantmp"
FETCH_ORIG="https://www.bs-korbach.de/images/vertretungsplan/"
FETCH_PASSWD="BSK:2020"

FETCH_CONF=""
FETCH_FILTER=""
FETCH_ADV_FILTER=""
FETCH_SHOW=""
FETCH_DATE=""

FETCH_HAS_WHICH="true"
FETCH_EXIT="false"

FETCH_HTML_BEGIN="<!DOCTYPE html><html><head><title>Wer das liest kann lesen</title></head><body style='background-color:black; color: white;'><div>"
FETCH_HTML_END="</div></body></html>"


if [ -z $(command -v pdftotext) ]; then
	echo "'pdftotext' not in PATH! Is poppler installed?"
	FETCH_EXIT="true"
fi

if [ -z $(command -v curl) ]; then
        echo "'curl' not in PATH! Is curl installed?"
        FETCH_EXIT="true"
fi

if [ -z $(command -v grep) ]; then
        echo "'grep' not in PATH! Are you even real?"
        FETCH_EXIT="true"
fi

if [ -z $(command -v which) ]; then
	echo "'which' not in PATH! This not an error, but 'which' is required for html output!"
	FETCH_HAS_WHICH="false"
fi

if [ $FETCH_EXIT == "true" ]; then
	exit
fi

if [ 0 != $(($#%2)) ]; then
	echo "Check for wrong usage!:"
	echo "-d <DAY> -f <FILTER> -o <OUTPUT> -a <ADVANCED_FILTER> -c <CONFIG_FILE>"
	echo "defaults for omitted fields are:"
	echo "current day, no filter and html"
	echo "if no filter was passed and output ist html"
	echo "the entire document will be downloaded and shown"
	echo "in your browser"
	exit
fi

if [ $# -ge 2 ]; then
	if [ $1 == "-d" ]; then
		FETCH_DATE=$2
	elif [ $1 == "-f" ]; then
		FETCH_FILTER=$2
	elif [ $1 == "-o" ]; then
		FETCH_SHOW=$2
	elif [ $1 == "-c" ]; then
		FETCH_CONF=$2 
	elif [ $1 == "-a" ]; then
		FETCH_ADV_FILTER=$2
	fi
fi

if [ $# -ge 4 ]; then
	if [ $3 == "-d" ]; then
		FETCH_DATE=$4
	elif [ $3 == "-f" ]; then
		FETCH_FILTER=$4
	elif [ $3 == "-o" ]; then
		FETCH_SHOW=$4
	elif [ $3 == "-c" ]; then
                FETCH_CONF=$4
	elif [ $3 == "-a" ]; then
                FETCH_ADV_FILTER=$4
	fi
fi

if [ $# -ge 6 ]; then
	if [ $5 == "-d" ]; then
		FETCH_DATE=$6
	elif [ $5 == "-f" ]; then
		FETCH_FILTER=$6
	elif [ $5 == "-o" ]; then
		FETCH_SHOW=$6
	elif [ $5 == "-c" ]; then
                FETCH_CONF=$6
	elif [ $5 == "-a" ]; then
                FETCH_ADV_FILTER=$6
	fi
fi

if [ $# -ge 8 ]; then
        if [ $7 == "-d" ]; then
                FETCH_DATE=$8
        elif [ $7 == "-f" ]; then
                FETCH_FILTER=$8
        elif [ $7 == "-o" ]; then
                FETCH_SHOW=$8
        elif [ $7 == "-c" ]; then
                FETCH_CONF=$8
        elif [ $7 == "-a" ]; then
                FETCH_ADV_FILTER=$8
        fi
fi

if [ $# -ge 10 ]; then
        if [ $9 == "-d" ]; then
                FETCH_DATE=$10
        elif [ $9 == "-f" ]; then
                FETCH_FILTER=$10
        elif [ $9 == "-o" ]; then
                FETCH_SHOW=$10
        elif [ $9 == "-c" ]; then
                FETCH_CONF=$10
        elif [ $9 == "-a" ]; then
                FETCH_ADV_FILTER=$10
        fi
fi

if [ -n "$FETCH_CONF" ]; then
	if [ -z $FETCH_FILTER ]; then
		FETCH_FILTER=$(cat $FETCH_CONF | grep '"filter"' | awk '{print $3}')
	fi
	if [ -z $FETCH_SHOW ]; then
		FETCH_SHOW=$(cat $FETCH_CONF | grep '"out"' | awk '{print $3}' | sed -e 's/^[ \t]*//')
	fi
	if [ -z $FETCH_DATE ]; then
		FETCH_DATE=$(cat $FETCH_CONF | grep '"day"' | awk '{print $3}' | sed -e 's/^[ \t]*//')
	fi

	if [ -z $FETCH_ADV_FILTER ]; then
		FETCH_ADV_FILTER=$(cat $FETCH_CONF | grep '"adv_filter"' | awk '{print $3}' | sed -e 's/^[ \t]*//')
	fi
else
	if [ -z $FETCH_FILTER ]; then
		FETCH_FILTER=""
	fi
        if [ -z $FETCH_SHOW ]; then
		FETCH_SHOW="html"
        fi
        if [ -z $FETCH_DATE ]; then
		FETCH_DATE="today"
        fi
fi

if [[ $FETCH_DATE == "today" ]]; then
	FETCH_DATE=$(date '+%A' | awk '{print tolower($0)}')
fi

if [[ $FETCH_ADV_FILTER == "none" ]]; then
	FETCH_ADV_FILTER=""
fi

if [[ $FETCH_FILTER == "none" ]]; then
	FETCH_FILTER=""
fi

rm $FETCH_DEST.* -f

http_code=$(curl -s  "${FETCH_ORIG}${FETCH_DATE}.pdf" --user "$FETCH_PASSWD" -w '%{http_code}\n' --output $FETCH_DEST.pdf)

if [ $((10#$http_code)) -ne $((10#200)) -o $((10#$?)) -ne $((10#0)) ]; then
	echo "curl failed to download file! |$http_code|$?|"
	exit
fi

pdftotext -layout $FETCH_DEST.pdf

out=$(cat $FETCH_DEST.txt | grep "$FETCH_FILTER")

if [ -n "$FETCH_ADV_FILTER" ]; then
	out=$(echo "$out" | grep -E "$FETCH_ADV_FILTER")
fi

if [ -z "$out" ]; then
        out="Kein Eintrag mit dem Filter gefunden"
fi

if [[ $FETCH_HAS_WHICH == "false" ]] && [[ $FETCH_SHOW == "html" ]]; then
	FETCH_SHOW="stdout"
fi

if [ $FETCH_SHOW == "stdout" ]; then
	echo "$out"
elif [ $FETCH_SHOW == "html" ]; then
	HTML_DEST_FID="html"
	if [[ $FETCH_FILTER == "" ]]; then
		HTML_DEST_FID="pdf"
	else
		touch ${FETCH_DEST}.${HTML_DEST_FID}

		echo "" > ${FETCH_DEST}.${HTML_DEST_FID} 
		echo "$FETCH_HTML_BEGIN" >> ${FETCH_DEST}.${HTML_DEST_FID}
		echo "$out" | while read line ; do

			for (( c=1; c<=$(echo "$line" | awk '{print NF}'); c++ ))
			do
				data=$(echo "$line" | awk "{ print \$$c }")
				if [ "$data" == "******" ]; then
					break
				fi
				echo "<span style='display: inline-block; width: 100px;'> $data </span>" >> ${FETCH_DEST}.${HTML_DEST_FID}
			done

			echo "<br>" >> ${FETCH_DEST}.${HTML_DEST_FID}
		done

		echo "$FETCH_HTML_END" >> ${FETCH_DEST}.${HTML_DEST_FID}
	fi

	[[ -x $BROWSER ]] && exec "$BROWSER" "${FETCH_DEST}.${HTML_DEST_FID}"
	path=$(which xdg-open || which gnome-open) && exec "$path" "${FETCH_DEST}.${HTML_DEST_FID}"
	if open -Ra "safari" ; then
	  open -a safari "${FETCH_DEST}.${HTML_DEST_FID}"
	else
	  echo "Can't find browser"
	fi
else
	echo "invalid output method!"
	echo "valid: 'stdout' or 'html'"
	echo "got: $FETCH_SHOW"
	exit
fi
