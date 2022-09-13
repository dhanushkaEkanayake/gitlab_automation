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
	getPRname
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
#   Function to get PR name       #
#                                 #
#=================================#

getPRname() {
	
    #----------Retrieve the PR name from the description
   	PRNAME=$(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN"\
                            -g "$GIT_API/groups/${GROUP_ID}" | jq -r ".description" | sed -n 's/.*\(\[PR:[^]]*]\).*/\1/p' | sed 's/\[PR:\([^][]*\)]/\1/')
	
    echo -e "\n ${PRNAME} \n"
    
    if [ -z "${PRNAME}" ] #-------Check whether is there any PR for the given group name or not
    then
    	echo -e "\n There is no PR tag \n"
        exit 1
    fi
}




#-------------------------------------------------------------Calling Main Function---------------------------------------------------------

main

#-------------------------------------------------------------------------------------------------------------------------------------------
 
