GIT_API="your_api_url"
GIT_TOKEN="your_personel_access_token"
GROUP_NAME="group_name"

#@@@@@@@@@@@@@@@@@@@@@#
#                     #
#    Main Function    #
#                     #
#@@@@@@@@@@@@@@@@@@@@@#


main() {
		
        getGroupID
	updateDescription
}


#====================================#
#                                    #
#    Function to get the Group ID    #
#                                    #
#====================================#


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
    
    #-----------Un comment this to print the retrieved group ID----------
    #	echo -e " "${GROUP_ID}""
    #--------------------------------------------------------------------
    
    if [ -z "${GROUP_ID}" ] #-------Check whether is there any group for the given group name or not
    then
    	echo -e "\n Invalid Group Name...!! \n"
        exit 1
    fi
}


#=================================#
#                                 #
#   Function to put Description   #
#                                 #
#=================================#

updateDescription() {
	
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
}




#-------------------------------------------------------------Calling Main Function---------------------------------------------------------

main

#-------------------------------------------------------------------------------------------------------------------------------------------
 
