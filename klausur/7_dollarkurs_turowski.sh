#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: dollarkurs

SYNOPSIS: 7_dollarkurs_turowski

PARAMETERS:

DESCRIPTION:  Gibt den akutellen Dollarkurs für Euros an.

AUTHOR: <Paul Turowski>
'
#---------------------------------------------------------------------------

curl -s https://markets.businessinsider.com/currencies/eur-usd | sed 's/,/\n/g' | grep currentValue | sed 's/.*://' | sed "s/$/ \$ /"
