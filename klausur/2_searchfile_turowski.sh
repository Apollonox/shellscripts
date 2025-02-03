#!/bin/bash -u
#---------------------------------------------------------------------------
ManPage='
NAME: Dateien suchen

SYNOPSIS: 2_searchfile_turowski

DESCRIPTION:  Gibt meine Lösungen für Aufgabe 2 aus und führt die Befehle aus.

AUTHOR: <Paul Turowski>
'
#---------------------------------------------------------------------------

echo 'a) ls | grep "2019[0-9]"'
ls | grep 2019[0-9]
echo 'b) ls | grep "*0101[._]"'
ls | grep *0101[._]
echo 'c) find . -type f -name "[A-Z]*" -ls'
find . -type f -name "[A-Z]*" -ls

exit 0
