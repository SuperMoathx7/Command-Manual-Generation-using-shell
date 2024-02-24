#!/usr/bin/bash


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
      	touch $i.txt
	printf "$i command\n" > $i.txt
#This is for description...
	if [ $i == 'lspci' -o $i == 'chown' -o $i == 'which' -o $i == 'alias' -o $i == 'free' ]
	then
        	printf "$(man $i | awk '/^DESCRIPTION$/,/^OPTIONS$/' | grep -v ^OPTIONS)\n" >>$i.txt
	elif [ $i == 'chmod' ]
	then 
		printf "$(man $i | awk '/^DESCRIPTION$/,/^SETUID/' | grep -v ^SETUID)\n" >>$i.txt
	else

		printf "$(man $i | awk '/^DESCRIPTION$/,/^$/') \n" >> $i.txt
	fi
#This is for version...
echo "_________________________________________________________________________________________" >>$i.txt
 #	printf "COMMAND VERSION\n" >> $i.txt
	if [ $i == "cd" -o $i == "pwd" -o $i == "cal" -o $i == "alias" -o $i == "which" ]
	then
		printf "COMMAND VERSION\tThe $i command doesn't have a version in the same way that some other commands do, Because it is a shell built-in command. This is the bash version : $(bash --version | sed -n "1p")"| column -W 2 -s $'\t' -t>>$i.txt
#		echo "This is the bash version :">>$i.txt
#		echo "$(bash --version | sed -n "1p")">>$i.txt
	else
	printf "COMMAND VERSION\t$($i --version | sed -n "1p")\n" | column -W 2 -s $'\t' -t >> $i.txt
	fi
#This is for the example...
echo "_________________________________________________________________________________________" >>$i.txt
#printf "EXAMPLE\t" >> $i.txt 	
	if [ $i == 'cd' ]
	then
		printf "EXAMPLE\tcd\n\tWill change your current directory to your home directory.\n"| column -W 2 -s $'\t' -t>>$i.txt
	elif [ $i == 'chmod' ]
	then
		printf "EXAMPLE\tchmod +x test.sh\n\tWill make 'test.sh' executable.\n"| column -W 2 -s $'\t' -t>>$i.txt
	elif [ $i == 'chown' ]
        then
		printf "EXAMPLE\tchown \$USER test.txt\n\tWill change the owenr of this file to \$USER\n"| column -W 2 -s $'\t' -t>>$i.txt
	elif [ $i == 'cat' ]
        then
		printf "EXAMPLE\tcat file.txt\n\tHello World From the First project!!\n"| column -W 2 -s $'\t' -t>>$i.txt
 	elif [ $i == 'which' ]
        then
		printf "EXAMPLE\twhich python3\n\t$($i python3)\n">>$i.txt
	elif [ $i == 'tr' ]
        then
		printf "EXAMPLE\techo \$PATH | tr ':' ' '\n\t $(echo $PATH | tr ':' ' ' )"|column -W 2 -s $'\t' -t>>$i.txt
		
	elif [ $i == 'ls' -o $i == 'cal' -o $i == 'lspci' -o $i == 'free' -o $i == 'ps' ]
	then
	       printf "EXAMPLE\n$i\n$($i)\n" | sed '1,2!s/^/        /'>> $i.txt
	else
		printf "EXAMPLE\t$i\n\t$($i)" |column -W 2 -s $'\t' -t >> $i.txt
	fi
#This is for Related commands...
echo "_________________________________________________________________________________________" >>$i.txt        
	echo "RELATED COMMANDS" >> $i.txt
	if [ $i == "lspci" ]
	then
		printf "$(compgen -c | grep pci)\n"| sed 's/^/        /'>>$i.txt
	elif [ $i == "uname" ]
	then
	 	echo "$(compgen -c | grep name)\n"| sed 's/^/        /'>>$i.txt
	elif [ $i == "chown" ]
	then
		echo "$(compgen -c | grep own)\n"| sed 's/^/        /'>>$i.txt
	elif [ $i == "chmod" ]
       then
                echo "$(compgen -c | grep mod)\n"| sed 's/^/        /'>>$i.txt
        elif [ $i == 'date' ]
        then 
        	echo "$(compgen -c | grep $i)\n" | grep -v update | sed 's/^/        /'>>$i.txt
	else
		echo "$(compgen -c | grep $i)\n"| sed 's/^/        /'>>$i.txt
	fi

echo "_________________________________________________________________________________________" >>$i.txt
     echo "You can also search for these commands too:" >>$i.txt   
     for f in $(ls)
	do
		if [ ! -x $f -a ! $f == "commandsnames.txt" -a ! -d $f ]
		then		
  				echo $f >> $i.txt	
		fi

	done
done
