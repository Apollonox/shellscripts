#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: commentpictures

SYNOPSIS:  [--help] [--verbose] [--display] <FILE LIST> <Directory>

DESCRIPTION: This script adds "Strasse und Hausnummer, Stadt, Bundesland, Staat" to the metadata of pictures, if data is available from the online api. Works for jpg, jpeg. To add other Formats please change script.
             Do not use lower and upper case letters in the same ending, that is just cruel.

PARAMETERS:  -d [Directory] -f [files]
        
OPTIONS:
    -h, --help 
        Output a usage message and exit.
    -d, --display
        Displays the Image in geeqie
        Careful, when used with directories
    -w, --write
        Writes the Commentheader in the Picture

EXIT CODE:
    0   There was no error.
    
    1   There was an error.

ENVIRONMENT:
        
EXAMPLES:   commentpictures exapmleimage.jpg
            commentpictures inputfotos/
            
REFERENCES:
        exiftool
        imagemagick
        curl
        jq
	geeqie
    
AUTHOR: <turowskipa64071@th-nuernberg.de>
'
HISTORY='
    07-Jan-2025     First version
    16-Jan-2025	    Version 0.1
'
#---------------------------------------------------------------------------

# Default values for options - feel free to change
VerboseMode=0
DisplayMode=0


# Internal variables
myname=$(basename "${0%.*sh}")

# ENVIRONMENT
hash exiftool 2>/dev/null || { echo >&2 "FATAL: I require exiftool but it's not installed.  Aborting."; exit 1; }
hash convert 2>/dev/null || { echo >&2 "FATAL: I require imagemagick but it's not installed.  Aborting."; exit 1; }
hash curl 2>/dev/null || { echo >&2 "FATAL: I require curl but it's not installed.  Aborting."; exit 1; }
hash jq 2>/dev/null || { echo >&2 "FATAL: I require jq but it's not installed.  Aborting."; exit 1; }
hash geeqie 2>/dev/null || { echo >&2 "FATAL: I require geeqie but it's not installed.  Aborting."; exit 1; }


while [[ "${1-}" =~ ^- ]] ; do
    case $1 in

        -h | --help)        echo "$ManPage" | 
                                sed  "s/^\([A-Z ]\+:\)/\d027[1m\\1\d027[0;39m/" | 
                                less --quit-if-one-screen --long-prompt --RAW-CONTROL-CHARS 
                                exit 0 ;;
        
        -o | --output)      OutputName=$2 ; shift ;;

        -v | --verbose)     VerboseMode=1  ;;

        -d | --display)     DisplayMode=1 ;;

        -w | --write)       WriteMode = 1 ;;
        
        --)                 shift ; break ;;
            
        *)                  echo "$myname FATAL: Invalid option $1."  >&2 ; exit 1 ;;
        
    esac
    shift
done

#check if less than 1 input
if [ $# -lt 1 ] ; then
    grep "SYNOPSIS\:" "$0" | sed -E "s/^# +//"
    exit 1
fi


#---------------------------------------------------------------------------
#    F u n c t i o n s
#---------------------------------------------------------------------------
comment_picture()
{
    filename=$1
    #Get Lat and Log as GPS Degree
    lat=$(exiftool -gpslatitude -nt $filename | cut -d":" -f2 | tr -d ' ' | tr -s 'deg' ' ' | tr -s "'" " " | tr -d '"NEWS' | awk ' {printf("%.4f", $1+$2/60+$3/3600)}' )
    long=$(exiftool  -gpslongitude -nt $filename | cut -d":" -f2 | tr -d ' ' | tr -s 'deg' ' ' | tr -s "'" " " | tr -d '"NEWS'| awk ' {printf("%.4f", $1+$2/60+$3/3600)}')

    #Get N/S W/E REFERENCES
    if [ "exiftool -gpslatituderef -nf" = "South" ] ; then
        $lat="-$lat"
        echo $lat
    fi
    if [ "exiftool -gpslongituderef -nf" = "West" ] ; then
        $long="-$long"
        echo $long
    fi

    [[ $VerboseMode = 1 ]] && echo "Latitude: $lat Longitude: $long"

    #check if Picture has no Coordinates
    if [ -z "$lat" ] || [ -z "$long" ] ; then
        echo "ERROR: Image $filename has no Coordinates"  >> /dev/stderr
        return 1
    fi

    echo -n .

    [[ $VerboseMode = 1 ]] && curl -s "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&accept-language=en&zoom=18"

    #Get Data from Api
    text=$(curl -s "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&accept-language=en&zoom=18" | jq -r '.address.house_number, .address.road, .address.city, .address.county, .address.state, .address.country | select(. != null)' |
	    tr -s '\n' ', ' | sed '$s/,$//' )

    echo -n .

    #Test if curl worked
    if [[ $? -gt 0 ]] ; then
        echo "$myname FATAL: curl did not work according to specification $? "  >&2
        exit 1
    fi

    #Add Text as Metadata Comment
    #Anhängen nicht löschen(mehrfach schreiben) oder ähnliches steht schon was drinnen??
    exiftool -Comment="$text" $filename >> /dev/null

    echo -n .

    #Add Text to Picture
    [[ WriteMode = 1 ]] && convert $filename -gravity South -background Black -fill White -pointsize 25 -annotate +0+0 "$text" $filename >> /dev/null

    echo -n .

    #Display Picture
    [[ $DisplayMode = 1 ]] && geeqie $filename #show comments
}

#---------------------------------------------------------------------------
#    M a i n   l o o p
#---------------------------------------------------------------------------

[[ $VerboseMode = 1 ]] && echo "$myname"


while [[ -n "${1-}" ]] ; do
    filename="$1"
    shift

    [[ $VerboseMode = 1 ]] && echo "-------- $filename --------"

    #Test if Input is File
    if [ -f "$filename" ]; then
        if [[ $filename == *.jpg || $filename == *.jpeg || $filename == *.JPG || $filename == *.JPEG ]] ; then
            comment_picture "$filename"
        else
            echo "Warning: File $filename is not a picture" >> /dev/stderr
        fi

    #Test if Input is Directory
    elif [ -d "$filename" ]; then
        echo "Files in Folder $filename will be processed"
        find $filename -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.JPEG' -iname '*.JPG' \) | while read -r image; do
            comment_picture "$image"
        done

    #else Error
    else
        echo "EROOR: Image $filename not found"  >> /dev/stderr
    fi

    echo .
done

[[ $VerboseMode = 1 ]] && echo "$myname done."
exit 0

