#!/bin/bash -u

fGetHardwareMemoryTotal()
{
	vmstat -sS m | grep "total memory" | sed 's@^[^0-9]*\([0-9]\+\).*@\1@'
}


ram=$(fGetHardwareMemoryTotal)

if [[ $ram -lt 2 ]]; then
	echo "Kinderrechner"
elif [[ $ram -le 8 ]]; then
	echo "Standardrechner"
else
	echo "Profirechner"
fi

