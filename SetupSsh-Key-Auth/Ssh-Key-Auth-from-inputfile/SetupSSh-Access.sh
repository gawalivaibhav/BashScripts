#!/bin/bash
##################################################################
#Aurthor:- vaibhav

##################################################################

function error_trap ()
{
if [ "$?" -ne "0" ]
then
        echo -e "Failed !!! \"$(basename $0)\"Script failed at \"$BASH_COMMAND\" command "
else
        echo -e "Success !!! Script \"$(basename $0)\" executed successfully in \"$SECONDS\" seconds"
fi
}

trap error_trap exit
set -e

if [ "$(which yum)" ==  "/usr/bin/yum" ]
then
        echo "CentOS"
        which ssh-pass || yum install sshpass -y
elif [ "$(which apt-get)" == "/usr/bin/apt-get" ]
then
        echo "Ubuntu"
        which ssh-pass || apt-get install sshpass -y
else
        echo " Please install \"ssh-pass\" to work this \"$(basename $0 \") script "

fi

OLDIFS=$IFS
IFS=","

cat inputfile.sh |grep -v "#" > /tmp/tmpinput.csv

while read f1 f2 f3 f4 f5 f6 f7 f8
do
        Hostname=${f1}
        Sshport=${f2}
        Sshuser=${f3}
	Sshuserpassword=${f4}

sshpass -p "$Sshuserpassword" ssh-copy-id -o StrictHostKeyChecking=no $Sshuser@$Hostname -p $Sshport

done < /tmp/tmpinput.csv
IFS=$OLDIFS

##Cleaning tmp file
rm -rf
