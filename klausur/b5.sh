#!/bin/bash -u
#
#
#

MIN=1 
until (( (MIN<<=1) < 0 )) ;do :;done
((MAX=MIN-1))

echo $MAX

