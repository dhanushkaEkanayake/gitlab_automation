GIT_API="http://gitlab.serverlab.com/api/v4"	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"	#replace with your personal access token
GROUP_NAME="test_one"
PR_NAME="Dhanushka"
                       
	
    #-----To get the number of group result pages
    total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups?owned=true&top_level_only=true&per_page=100" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')
    
    for (( d=1; d<=${total_pages+1}; d++ ))
	do
    	#------get the current text from the group description
		DESCRIPTION+=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN"\
                            -g "$GIT_API/groups?owned=true&top_level_only=true&per_page=100&page=${d}&search="$GROUP_NAME"" | jq -r ".[] .description")
	done
    
    	if [[ ${DESCRIPTION} == *"[PR:"* ]]; #-------Check whether is there already any PR tag or not 
    		then
    	
        		echo "${DESCRIPTION}" | sed "s/\[PR:[^]]*\]/[PR:${PR_NAME}]/g" | sed 's/ /%20/g'> dump.txt #-------Replace the old PR name with new PR name
        		DESCRIPTION=$(cat dump.txt)
       			rm -rf dump.txt
        
        		echo -e "${DESCRIPTION}"
        
        		curl --silent --output /dev/null --request PUT --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups/${GROUP_ID}?description=${DESCRIPTION}"
	
    			echo -e "\n The PR tag has been updated..!! \n"
			exit 0
    
    	else
    		DESCRIPTION+="[PR:${PR_NAME}]" #------- Appending PR tag into the group description

		echo -e "${DESCRIPTION}"

		echo "${DESCRIPTION// /%20}" > dump.txt #--------Replace the spaces with space url encode

		DESCRIPTION=$(cat dump.txt)
      		rm -rf dump.txt

		curl --silent --output /dev/null --request PUT --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/groups/${GROUP_ID}?description=${DESCRIPTION}"
		
	fi	
