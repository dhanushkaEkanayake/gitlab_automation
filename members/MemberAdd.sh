GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_NAME="test_one"

main(){

	getGroupID
	getAllUsers
	addMembers	
}


getGroupID() {

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



getAllUsers(){


	total_pages=$(curl -s -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

	
	for (( d=1; d<=${total_pages+1}; d++ ))
	do
    		
		USER_ID_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?per_page=100&page=${d}" | jq -r ".[] .id"))

		USER_NAME_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?per_page=100&page=${d}" | jq -r ".[] .username"))
    	
	done

}


addMembers(){
	
	readarray -t MEMBER_NAME_ARRAY < sampleMembersNames.txt


	for (( c=0; c<${#USER_NAME_ARRAY[@]}; c++ ))
	do
		for (( a=0; a<${#MEMBER_NAME_ARRAY[@]}; a++ ))
		do
			if [[ ${USER_NAME_ARRAY[$c]} == ${MEMBER_NAME_ARRAY[$a]} ]]
			then
				MEMBER_ID_ARRAY+=(${USER_ID_ARRAY[$c]})
			fi
		done
	done

	

	for (( e=0; e<${#MEMBER_ID_ARRAY[@]}; e++ ))
        do
		curl -s --request POST --header "PRIVATE-TOKEN: $GIT_TOKEN" \
     			--data "user_id=${MEMBER_ID_ARRAY[$e]}&access_level=30" "$GIT_API/groups/${GROUP_ID}/members"
	done

}



main
