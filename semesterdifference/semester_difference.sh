#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: semester-difference 

SYNOPSIS:  semester_difference [--help] 
           semester_difference [argument1] [argument2]

DESCRIPTION: Shows the Time Difference in Half Years between two semesters. 
             WSXX is the year the semester starts in not the one it ends in. 

PARAMETERS: Enter arguments in form WS/SSXX  (not case sensitive)
            Argument 1 is first semester
            Argument 2 is last semester
        
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
    
AUTHOR: <Paul Turowski>
'
HISTORY='
    20-Nov-2024     First version
'
#---------------------------------------------------------------------------

# Default values for options - feel free to change

# Internal variables

while [[ "${1-}" =~ ^- ]] ; do
    case $1 in
        -h | --help)        echo "$ManPage" | 
                                sed  "s/^\([A-Z ]\+:\)/\d027[1m\\1\d027[0;39m/" | 
                                less --quit-if-one-screen --long-prompt --RAW-CONTROL-CHARS 
                                exit 0 ;;
	*) 			exit 1 ;;
        esac
done

if [[  $# -ne 2 ]]; then
  echo "ERROR: wrong number of arguments" >> /dev/stderr
  echo "Please enter 2 arguments" 
  exit 1
fi

if [[ "$1" != [WSws][Ss][0-9][0-9] && "$1" != [WwSs][Ss]2[0][0-9][0-9] ]]; then
	echo "First semester: Invalid option $1." >> /dev/stderr
        exit 1
fi

if [[ "$2" != [WSws][Ss][0-9][0-9] && "$2" != [WwSs][Ss]2[0][0-9][0-9] ]]; then
        echo "Last semester: Invalid option $2." >> /dev/stderr
        exit 1
fi

digit1=${1:(-2):2}
digit1=${digit1#0}
digit2=${2:(-2):2}
digit2=${digit2#0}
semester1=${1:0:2}
semester2=${2:0:2}

((digit=$digit2-$digit1))

if (( $digit < 0 )); then
   echo "ERROR: start year is after end year" >> /dev/stderr 
   echo "Please first the start semester then the last semester" >> /dev/stderr
   exit 1
fi

if [[ $semester1 = $semester2 ]]; then
   (( studiendauer = $digit*2+1 ))
elif [[ $semester1 > $semester2 ]]; then
     (( studiendauer = $digit*2 ))
elif [[ $semester1 < $semester2 ]]; then
   if [[ $digit1 = $digit2 ]]; then 
     echo "ERROR: errorcode" >> /dev/stderr
     echo "Please first the start semester then the last semester" >> /dev/stderr
     exit 1
   else
   (( studiendauer = $digit*2+2 ))
   fi
else
   echo "unexpected Error" >> /dev/stderr
fi

echo Studyduration: $studiendauer. semester 
exit 0
