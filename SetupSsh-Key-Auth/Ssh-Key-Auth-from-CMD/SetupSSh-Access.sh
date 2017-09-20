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

echo -e "Please provide the Server IP "
read ServerIP

echo -e "Please provide Server's ssh port"
read Sshport

echo -e "Please provide the user name"
read Username

echo -e "Please provide the password"
read Password

#sshpass -p server_password ssh-copy-id user@IP -p port_number
sshpass -p "$Password" ssh-copy-id -o StrictHostKeyChecking=no $Username@$ServerIP -p $Sshport
