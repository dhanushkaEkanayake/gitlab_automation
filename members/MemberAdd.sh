GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_ID="12"

	total_pages=$(curl -s -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

	
	for (( d=1; d<=${total_pages+1}; d++ ))
	do
    		
		USER_ID_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?per_page=100&page=${d}" | jq -r ".[] .id"))

		USER_NAME_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?per_page=100&page=${d}" | jq -r ".[] .username"))
    	
	done

	
	readarray -t MEMBER_NAME_ARRAY < sampleMembersNames.txt


	for (( c=0; c<${#USER_NAME_ARRAY[@]}; c++ )) #------Determine the user IDs of the members without ownership
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


