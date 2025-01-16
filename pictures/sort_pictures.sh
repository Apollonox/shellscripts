#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: template - this script does perfectly nothing

SYNOPSIS:  [--help] [--verbose] <FILE LIST>

DESCRIPTION: 

PARAMETERS:  
        
OPTIONS:
    -h, --help 
        Output a usage message and exit.


EXIT CODE:
    0   There was no error.
    
    1   There was an error.

ENVIRONMENT:
    TMP
        Directory for temporary files.
        
EXAMPLES:
            
REFERENCES:
    
AUTHOR: <turowskipa64071@th-nuernberg.de>
'
HISTORY='
    29-Jan-2024     First version
'
#---------------------------------------------------------------------------

# Default values for options - feel free to change
VerboseMode=0
OutputName="output.txt"


# Internal variables
myname=$(basename "${0%.*sh}")


while [[ "${1-}" =~ ^- ]] ; do
    case $1 in

        -h | --help)        echo "$ManPage" | 
                                sed  "s/^\([A-Z ]\+:\)/\d027[1m\\1\d027[0;39m/" | 
                                less --quit-if-one-screen --long-prompt --RAW-CONTROL-CHARS 
                                exit 0 ;;
        
        -o | --output)      OutputName=$2 ; shift ;;

        -v| --verbose)      VerboseMode=1  ;;
        
        --)                 shift ; break ;;
            
        *)                  echo "$myname FATAL: Invalid option $1."  >&2 ; exit 1 ;;
        
    esac
    shift
done


if [ $# -ne 1 ] ; then
    grep "SYNOPSIS\:" "$0" | sed -E "s/^# +//"
    exit 1
fi


#---------------------------------------------------------------------------
#    M a i n   l o o p
#---------------------------------------------------------------------------

[[ $VerboseMode = 1 ]] && echo "$myname OutputName=$OutputName"


while [[ -n "${1-}" ]] ; do
    inputdir=$1

    if [ ! -d "$inputdir" ] ; then
	    echo "$inputdir is not a directory" >> dev/stderr
	    exit 1
    fi

    [[ $VerboseMode = 1 ]] && echo "-------- $Filename --------"
    [[ $VerboseMode = 1 ]] && echo $inputdir "wird bearbeitet"

    # Create an output directory
    OUTPUT_DIR="${inputdir%/}/info"
    mkdir -p "$OUTPUT_DIR"

    find $inputdir -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | while read -r image; do
        echo 'Renaming $image to Date...'
        exiftool -d '%Y-%m-%d-%%-03.c.%%e' '-filename<DateTimeOriginal' "$image"
        echo '$image bearbeitet'
    done

    # TODO use jpegoptim to optimze the size of jpegs


    find $inputdir -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | while read -r image; do
    	echo 'Moving $image to folder of Year/Month...'
        exiftool -o . -d '%Y/%b' '-Directory<$DateTimeOriginal' "$image"
        echo '$image bearbeitet'
    done


    exit 0
done

[[ $VerboseMode = 1 ]] && echo "$myname done."

if [[ $? -gt 0 ]] ; then
        echo "$myname FATAL: "  >&2
        exit 1
    fi

exit 0
