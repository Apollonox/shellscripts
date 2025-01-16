#!/bin/bash -u
#
#

curl -s https://markets.businessinsider.com/currencies/eur-usd | sed 's/,/\n/g' | grep currentValue | sed 's/.*://' | sed "s/$/ \$ /"
