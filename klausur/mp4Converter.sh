#!/bin/bash
#
#

while [[ "${1-}" =~ ^- ]] ; do
    case $1 in

        -h | --help)        echo "$ManPage" |
                                sed  "s/^\([A-Z ]\+:\)/\d027[1m\\1\d027[0;39m/" |
                                less --quit-if-one-screen --long-prompt --RAW-CONTROL-CHARS
                                exit 0 ;;

        -o | --output)      OutputName=$2 ; shift ;;

        -v | --verbose)     VerboseMode=1  ;;

        --)                 shift ; break ;;

        *)                  echo "$myname FATAL: Invalid option $1."  >&2 ; exit 1 ;;

    esac
    shift
done

if [[  $# -lt 1 ]]; then
  echo "ERROR: wrong number of arguments" >> /dev/stderr
  exit 1
fi

while [[ -n "${1-}" ]] ; do
	oldname=$(basename "$1")
    	shift


	if ! [[ $oldname == *.wmv || $oldname == *.mkv || $oldname == *.mp3 ]]; then
		echo "$oldname is not a song"
		exit 1
	fi

	if [[ $video == '*.mp4' ]]; then
		echo "Warning: This is already an mp4" >> /dev/stderr
	fi
	
	newname="${oldname%.*}.mp4"
	
	echo ffmpeg -i "$oldname" "$newname"

done

exit 0
