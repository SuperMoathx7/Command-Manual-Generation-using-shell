#!/usr/bin/bash

if [ $# -ne 0 ]
then 
	echo "this function does not take arguments."
	exit 2
fi


HISTFILE=~/.bash_history  # Set the history file.
HISTTIMEFORMAT='%F %T '   # Set the hitory time format.
set -o history            # Enable the history.



touch fir

history | tr '  ' ':' | cut -d: -f9 | grep -v 'history' | grep -v '^./' |  tail -n100 | sort | uniq  > fir

touch comnum

printf "">comnum

while read line
do
 	history | tr '  ' ':' | cut -d: -f9 | grep -v 'history' | grep -v '^./' | tail -n100 | grep -c $line >> comnum
done < fir


paste comnum fir > fin           # i can put -d'' to make the delemeter space, but i prefered to use tr hehehe.....

cat fin | sort -rn | tr '\t' ' ' | cut -d' ' -f2
rm fir
rm fin
rm comnum