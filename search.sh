#!/usr/bin/bash

if [ $# -ne 2 -o -z "${1//[0-9]}" ]
then 
	echo "You must enter two arguments, the first one is the  name of commands file, second is the word to search on it."
	exit 2
fi

comname=()
file=$1
tosearch=$2

while read line
do
	comname[$z]=$line
	z=$((z+1))
done < $file

for i in ${comname[@]}
do
	man $i | grep $tosearch >> teest
	 if [ $? -eq 0 ]
	 then
	 	printf "${i}.txt\n"
	fi
done
if [ ! -s teest ]
then 
	echo "There is no commands with this word on its manual."
fi
rm teest
