#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: convert_videos

SYNOPSIS: 6_mp4converter_turowski [argument]

PARAMETERS: Ein oder mehrere Songs im wmv,mkv oder mp3 Format

DESCRIPTION:  Faked die Umwandlung einer Datein nach mp4

OPTIONS:
    -h, --help
        Output a usage message and exit.


EXIT CODE:
    0   There was no error.

    1   There was an error.

AUTHOR: <Paul Turowski>
'
#---------------------------------------------------------------------------

while [[ "${1-}" =~ ^- ]] ; do
    case $1 in

        -h | --help)        echo "$ManPage" |
                                sed  "s/^\([A-Z ]\+:\)/\d027[1m\\1\d027[0;39m/" |
                                less --quit-if-one-screen --long-prompt --RAW-CONTROL-CHARS
                                exit 0 ;;

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
		exit 1
	fi
	
	newname="${oldname%.*}.mp4"
	
	echo ffmpeg -i "$oldname" "$newname"

done

exit 0
