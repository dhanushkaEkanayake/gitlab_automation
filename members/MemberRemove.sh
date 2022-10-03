#! /bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"	#replace with your personal access token
GROUP_NAME="test_one"

main(){
	
	getGroupID
	getMemberDetails
	removeMembers
		
}


getGroupID(){
	
	#-----To get the no of group result pages
	total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups?owned=true&top_level_only=true&per_page=100" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')
    
    
	for (( d=1; d<=${total_pages+1}; d++ ))
	do
    		#------To retrieve the corresspondance group name for the given group name
		GROUP_NAME_DUMP+=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN"\
 								-g "$GIT_API/groups?owned=true&top_level_only=true&per_page=100&page=${d}&search="$GROUP_NAME"" | jq -r ".[] .name")
    
    		if [[ "${GROUP_NAME_DUMP}" == "${GROUP_NAME}"  ]]; #-------Comapare the correspondance group name with given group name
		then
			GROUP_ID=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN"\
                        	-g "$GIT_API/groups?owned=true&top_level_only=true&per_page=100&page=${d}&search=$GROUP_NAME" | jq -r ".[] .id")
 		fi      
    	done
    
    	#----Un comment this to print the retrieved group ID------
	#	echo -e " "${GROUP_ID}""
	#----------------------------------------------------------
    
    	if [ -z "${GROUP_ID}" ] #-------Check whether is there any group for the given group name or not
    	then
    		echo -e "\n Invalid Group Name...!! \n"
        	exit 1
    	fi
}


getMemberDetails(){
	

	#-------To get the no of members result pages
    	total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members?per_page=100" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')
   
   
    	for (( d=1; d<=${total_pages+1}; d++ ))
	do
    		#------Retrieve the user ids and their access levels of the members in the group
   		USER_ID_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members?per_page=100&page=${d}" | jq -r ".[] .id"))
        	USER_ACCESS_LEVEL_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/members?per_page=100&page=${d}" | jq -r ".[] .access_level"))
    	done	
    

	#-------Un comment this to print retrieved user IDs----------
		echo ${USER_ID_ARRAY[*]}
	#------------------------------------------------------------
    
    	#---Un comment this to print retrieved user access levels----
		echo ${USER_ACCESS_LEVEL_ARRAY[*]}
	#------------------------------------------------------------

}


removeMembers(){
	
	
	for (( c=0; c<${#USER_ACCESS_LEVEL_ARRAY[@]}; c++ )) #------Determine the user IDs of the members without ownership
	do
        	if [ ${USER_ACCESS_LEVEL_ARRAY[$c]} != 50 ]
		then
			MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY+=(${USER_ID_ARRAY[$c]})
            		MEMBERS_WITHOUT_OWNERSHIP_USER_ACCESS_LEVEL_ARRAY+=(${USER_ACCESS_LEVEL_ARRAY[$c]})
		fi
	done

	if [ -z "${MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY}" ]; #------Determine there are members to be remove or not
	then
		echo -e "No members to remove "
	else

		for (( e=0; e<${#MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY[@]}; e++ )) #------Remove the members 
        	do
             		curl -sS --request DELETE --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups/$GROUP_ID/members/${MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY[$e]}"
        	done

		echo -e " Following Members are removed "
		
		for (( d=0; d<${#MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY[@]}; d++ )) #-------Retrieve the name of the members without ownership
        	do
              		curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?id=${MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY[d]}" | jq -r ".[] .name"
		done
        
        	printf "%s\n" "${MEMBERS_WITHOUT_OWNERSHIP_USER_ID_ARRAY[@]}" > ${GROUP_ID}_userID.txt

        	printf "%s\n" "${MEMBERS_WITHOUT_OWNERSHIP_USER_ACCESS_LEVEL_ARRAY[@]}" > ${GROUP_ID}_userAccessLevel.txt

	fi
}


main
