#!/bin/bash
##################################################################################
#Name:-Vaibhav Gawali
#Dependancy : you have to install jq to parse json output "yum install jq"
#How to use : Provide the value of "Private_Token" and "Hostname" of Gitlab server
##################################################################################
Private_Token=""
Hostname=""

exit_trap()
{
        if [ $? -ne 0 ]; then

                echo "{\"Status\":\"Failure\",\"Message\": Scritp \"$(basename $0)\" got failed at \"$BASH_COMMAND\" command with error code \"$?\"}"
                exit 1
        else
cat >>Project_info.html<<EOF
</tbody>
</table>
</div>
<h5><p align=center> www.yourdomain.com </p></h5>
EOF
                echo "{\"Status\":\"Success\",\"Message\": Script \"$(basename $0)\" executed successfully in \"${SECONDS}\" seconds}"
        fi

}

trap exit_trap EXIT
set -e

####Get the list of Projetcs
Project_ID=($(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/ |jq -S --tab .[] |(jq .id)))
echo "<h2> <p align='center'> <font color='#1ab394'><b>Projects Summary</b></font></p></h2>" > Project_info.html
echo "<h5> <p align='right'> <font color='#1ab394'><b>Last Updated at: `date`</b></font></p></h5>" >> Project_info.html
cat >>Project_info.html<< EOF
<div>
<table style='width:100%' class='table table-hover'>
<thead>
  <tr>
    <th>Project_Name</th>
    <th>Owner_Name</th>
    <th>Created_Date</th>
    <th>Contributors</th>
  </tr>
</thead>
<tbody>
EOF

for Project_ID in ${Project_ID[*]};
        do

Project_Name=($(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/$Project_ID |jq .name))

echo -e "$Project_ID :$Project_Name"

Owner_ID=($(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/$Project_ID |jq -S --tab .owner|(jq .id)))
Owner_Name=($(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/$Project_ID |jq -S --tab .owner|(jq .username)))
Created_Date=$(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/$Project_ID |jq .created_at | sed 's/\"//g' |cut -d "T" -f "1")
Contributors=$(curl -sk --header "PRIVATE-TOKEN: $Private-Token" https://$Hostname/api/v3/projects/$Project_ID/members |jq .[] |(jq .username)|tr '\n' ','|sed 's/,/, /g'|sed 's/,$//g'|sed 's/\(.*\),/\1 /')

echo $Contributors
cat >>Project_info.html<< EOF
  <tr>
    <td>$Project_Name</td>
    <td>$Owner_Name</td>
    <td>$Created_Date</td>
    <td>$Contributors</td>
  </tr>
EOF

        done

