#!/bin/bash -u
#
#

size=$1

if ! [[ $1 =~ ^[0-9]+$ ]]; then 
	echo "error: Not a number" >&2; exit 1 
fi

for (( i=0; i<$size; i++ )); do
	echo -n "*"
done
echo 
for (( i=0; i<($size-2)/2; i++ )); do
	echo -n "*"
	for (( j=0; j<=$size-3; j++ )); do
		echo -n " "
	done
	echo "*"
done
for (( i=0; i<$size; i++ )); do
	echo -n "*"
done
echo
