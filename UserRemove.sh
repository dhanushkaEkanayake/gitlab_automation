#! /bin/bash

GIT_API="https://git.zone24x7.lk/api/v4"
GIT_TOKEN="bVJ9jFDovV6vUEg-UmCt"
#GROUP_NAME="testdevops"
GROUP_NAME=$1

if [ "$1" == "" ] || [ $# -gt 1 ];
then
        echo -e "\n Please try with valid Group Name...!! \n"
else


#----------------------------------------------------------------------------------------Retrieve the Group ID--------------------------------------------------------------------------------------------

	GROUP_ID=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups?top_level_only=true&search=${GROUP_NAME}" | jq -r ".[] .id")

	echo -e "\n [-----------------------------Group Member delete Process Started---------------------------------] \n\n The selected Group Name is: ${GROUP_NAME} and ID is: ${GROUP_ID}\n"

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#--------------------------------------------------------------------Retrieve the User ID and Access Levels of members in the Group------------------------------------------------------------------------

	USER_ID_ARRAY=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members" | jq -r ".[] .id"))

	USER_ACCESS_LEVEL_ARRAY=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members" | jq -r ".[] .access_level"))

	#echo ${USER_ACCESS_LEVEL_ARRAY[*]}

	echo -e "\n Following members are in the group \n "

	for (( i=0; i<${#USER_ID_ARRAY[@]}; i++ ))
	do
        	echo -e " ${USER_ID_ARRAY[$i]}"
	done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#-----------------------------------------------------------------------------Determine the Non owner member----------------------------------------------------------------------------------------------

	for (( c=0; c<${#USER_ACCESS_LEVEL_ARRAY[@]}; c++ ))
	do
        	if [ ${USER_ACCESS_LEVEL_ARRAY[$c]} != 50 ]
		then
		NON_OWNER_USERS_ID_ARRAY+=(${USER_ID_ARRAY[$c]})
		fi
#! /bin/bash

GIT_API="https://git.zone24x7.lk/api/v4"
GIT_TOKEN="bVJ9jFDovV6vUEg-UmCt"
#GROUP_NAME="testdevops"
GROUP_NAME=$1

if [ "$1" == "" ] || [ $# -gt 1 ];
then
        echo -e "\n Please try with valid Group Name...!! \n"
else


#----------------------------------------------------------------------------------------Retrieve the Group ID--------------------------------------------------------------------------------------------

	GROUP_ID=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups?top_level_only=true&search=${GROUP_NAME}" | jq -r ".[] .id")

	echo -e "\n [-----------------------------Group Member delete Process Started---------------------------------] \n\n The selected Group Name is: ${GROUP_NAME} and ID is: ${GROUP_ID}\n"

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#--------------------------------------------------------------------Retrieve the User ID and Access Levels of members in the Group------------------------------------------------------------------------

	USER_ID_ARRAY=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members" | jq -r ".[] .id"))

	USER_ACCESS_LEVEL_ARRAY=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members" | jq -r ".[] .access_level"))

	#echo ${USER_ACCESS_LEVEL_ARRAY[*]}

	echo -e "\n Following members are in the group \n "

	for (( i=0; i<${#USER_ID_ARRAY[@]}; i++ ))
	do
        	echo -e " ${USER_ID_ARRAY[$i]}"
	done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#-----------------------------------------------------------------------------Determine the Non owner member----------------------------------------------------------------------------------------------

	for (( c=0; c<${#USER_ACCESS_LEVEL_ARRAY[@]}; c++ ))
	do
        	if [ ${USER_ACCESS_LEVEL_ARRAY[$c]} != 50 ]
		then
		NON_OWNER_USERS_ID_ARRAY+=(${USER_ID_ARRAY[$c]})
		fi
	done

	
	echo -e "\n Following members will be removed from the group \n "


	for (( d=0; d<${#NON_OWNER_USERS_ID_ARRAY[@]}; d++ ))
	do
        	echo -e " ${NON_OWNER_USERS_ID_ARRAY[$d]}"
	done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





#----------------------------------------------------------------------------------------Removing Members------------------------------------------------------------------------------------------------

	for (( e=0; e<${#NON_OWNER_USERS_ID_ARRAY[@]}; e++ ))
	do
        	curl -sS --request DELETE --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups/$GROUP_ID/members/${NON_OWNER_USERS_ID_ARRAY[$e]}"
	done

	echo -e "\n SuccessFull!!\n"

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

fi
