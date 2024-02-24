#!/usr/bin/bash
#This will be the same code as practise, buy i will do different folders and compare the new with prev, then delete them
if [ $# -ne 1 -o -z "${1//[0-9]}" ] # the second exprstion is to check if the string is only number or not, this format is used like this "var//patern/replace" so here we replce the numbers by nothing, and -z checks if the remaining string is empty or not.....
then 
	echo "You must enter one argument, the name of the commands file."
	exit 1
fi
comname=()

file=$1
z=0

while read line
do
	comname[$z]=$line
	z=$((z+1))
done < $file

#Now the reading process is done. The array 'comname' contains all commands name....

for i in ${comname[@]}
do
#Now 'i' will iterate all commands names....
        touch ${i}2.txt
        printf "$i command\n" > ${i}2.txt
#This is for description...
	if [ $i == 'lspci' -o $i == 'chown' -o $i == 'which' -o $i == 'alias' -o $i == 'free' ]
	then
        	printf "$(man $i | awk '/^DESCRIPTION$/,/^OPTIONS$/' | grep -v ^OPTIONS)\n" >>${i}2.txt
	elif [ $i == 'chmod' ]
	then 
		printf "$(man $i | awk '/^DESCRIPTION$/,/^SETUID/' | grep -v ^SETUID)\n" >>${i}2.txt
	else

		printf "$(man $i | awk '/^DESCRIPTION$/,/^$/') \n" >> ${i}2.txt
	fi
#This is for version...
echo "_________________________________________________________________________________________" >>${i}2.txt
       # printf "COMMAND VERSION\n" >> ${i}2.txt
        if [ $i == "cd" -o $i == "pwd" -o $i == "cal" -o $i == "alias" -o $i == "which" ]
	then
		printf "COMMAND VERSION\tThe $i command doesn't have a version in the same way that some other commands do, Because it is a shell built-in command. This is the bash version : $(bash --version | sed -n "1p")"| column -W 2 -s $'\t' -t>>${i}2.txt
#		echo "This is the bash version :">>${i}2.txt
#		echo "$(bash --version | sed -n "1p")">>${i}2.txt
	else
	printf "COMMAND VERSION\t$($i --version | sed -n "1p")\n" | column -W 2 -s $'\t' -t >> ${i}2.txt
	fi
#This is for the example...
echo "_________________________________________________________________________________________" >>${i}2.txt
#printf "EXAMPLE\n" >> ${i}2.txt
        if [ $i == 'cd' ]
	then
		printf "EXAMPLE\tcd\n\tWill change your current directory to your home directory.\n"| column -W 2 -s $'\t' -t>>${i}2.txt
	elif [ $i == 'chmod' ]
	then
		printf "EXAMPLE\tchmod +x test.sh\n\tWill make 'test.sh' executable.\n"| column -W 2 -s $'\t' -t>>${i}2.txt
	elif [ $i == 'chown' ]
        then
		printf "EXAMPLE\tchown \$USER test.txt\n\tWill change the owenr of this file to \$USER\n"| column -W 2 -s $'\t' -t>>${i}2.txt
	elif [ $i == 'cat' ]
        then
		printf "EXAMPLE\tcat file.txt\n\tHello World From the First project!!\n"| column -W 2 -s $'\t' -t>>${i}2.txt
 	elif [ $i == 'which' ]
        then
		printf "EXAMPLE\twhich python3\n\t$($i python3)\n">>${i}2.txt
	elif [ $i == 'tr' ]
        then
		printf "EXAMPLE\techo \$PATH | tr ':' ' '\n\t $(echo $PATH | tr ':' ' ' )"|column -W 2 -s $'\t' -t>>${i}2.txt
		
	elif [ $i == 'cal' -o $i == 'lspci' -o $i == 'free' -o $i == 'ps' ]
	then
	       printf "EXAMPLE\n$i\n$($i)\n" | sed '1,2!s/^/        /'>> ${i}2.txt
	elif [ $i == 'ls' ]
	then
	 		printf "EXAMPLE\n$i\n$($i)\n" | grep -v ls2.txt | sed '1,2!s/^/        /'>> ${i}2.txt
	else
		printf "EXAMPLE\t$i\n\t$($i)" |column -W 2 -s $'\t' -t >> ${i}2.txt
	fi
#This is for Related commands...
echo "_________________________________________________________________________________________" >>${i}2.txt        
echo "RELATED COMMANDS" >> ${i}2.txt
	if [ $i == "lspci" ]
	then
		printf "$(compgen -c | grep pci)\n"| sed 's/^/        /'>>${i}2.txt
	elif [ $i == "uname" ]
	then
	 	echo "$(compgen -c | grep name)\n"| sed 's/^/        /'>>${i}2.txt
	elif [ $i == "chown" ]
	then
		echo "$(compgen -c | grep own)\n"| sed 's/^/        /'>>${i}2.txt
	elif [ $i == "chmod" ]
       then
                echo "$(compgen -c | grep mod)\n"| sed 's/^/        /'>>${i}2.txt
        elif [ $i == 'date' ]
        then 
        	echo "$(compgen -c | grep $i)\n" | grep -v update | sed 's/^/        /'>>${i}2.txt
	else
		echo "$(compgen -c | grep $i)\n"| sed 's/^/        /'>>${i}2.txt
	fi
echo "_________________________________________________________________________________________" >>${i}2.txt
     echo "You can also search for these commands too:" >>${i}2.txt
     for f in $(ls)
        do
                if [ ! -x $f -a ! $f == "commandsnames.txt" -a ! $f == ${i}2.txt ]
                then
                                echo $f >> ${i}2.txt
                fi

        done
#The checking operation....
       if diff $i.txt ${i}2.txt > /dev/null
       then
	       echo "the $i text file is still the same."
  	else
	       echo "the $i text file has changed."
	      echo "And this is why: "
	      diff $i.txt ${i}2.txt
       fi
      
rm ${i}2.txt       

done
