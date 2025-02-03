#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: maxint

SYNOPSIS: 5_maxint_turowski

PARAMETERS:

DESCRIPTION:  Gibt den maximalen Wert für int an.

AUTHOR: <Paul Turowski>
'
#---------------------------------------------------------------------------

MIN=1 
until (( (MIN<<=1) < 0 )) ;do :;done
((MAX=MIN-1))

echo $MAX

exit 0
