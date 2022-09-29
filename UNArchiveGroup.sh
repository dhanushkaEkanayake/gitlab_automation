#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_NAME="test_one"

#@@@@@@@@@@@@@@@@@@@@@#
#                     #
#    Main Function    #
#                     #
#@@@@@@@@@@@@@@@@@@@@@#

main() {

	
	getGroupID
	echo -e "\n============================================ Start =========================================\n"
	echo -e "The selected Main Group name is '${GROUP_NAME}'"
        echo -e "\nUn Archiving Repo.........................Started "
	archiveProjects
	echo -e "Un Archiving Repo........................Finished \n "
	echo -e "\n=========================================== Finished ========================================\n"
        
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
    
    	#----Un comment this to print the retrieved group ID------
	#	echo -e " "${GROUP_ID}""
	#----------------------------------------------------------
    
    	if [ -z "${GROUP_ID}" ] #-------Check whether is there any group for the given group name or not
    	then
    		echo -e "\n Invalid Group Name...!! \n"
        	exit 1
    	fi
}



#======================================#
#                                      #
#   Function to archive the projects   #
#                                      #
#======================================#

archiveProjects() {
	
    #-----To get the no of project result pages
	total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&archived=true&per_page=100" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')
	
	for (( d=1; d<=${total_pages};   d++ ))
	do
    	#------Retrieve the project IDs and names which in unarchive state for the given group
		PROJECT_ID_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&page=${d}&archived=true" | jq -r '.[] .id'))
        	PROJECT_NAME_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&archived=true&per_page=100&page=${d}" | jq -r '.[] .name'))
	done

  	#----Un comment this to print the retrieved IDs of the non archived projects-----
	#	echo ${PROJECT_ID_ARRAY[*]}
	#--------------------------------------------------------------------------------
  
	
    	if [ -z "${PROJECT_ID_ARRAY}"  ]; #-------Check whether are there any projects to be archived or not
	then
		echo -e "There are no Repos to un archive"
		echo -e "Un Archiving Repo........................Finished \n "
        	echo -e "\n=========================================== Finished ========================================\n"
		exit 0
	else
    
    		echo -e "\nThere are ${#PROJECT_ID_ARRAY[@]} repos to be un archived\n"
    
		for (( d=0; d<${#PROJECT_ID_ARRAY[@]}; d++ ))
        	do
        		curl --silent --output /dev/null --request POST --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/projects/${PROJECT_ID_ARRAY[$d]}/unarchive"
            		echo -e " ${PROJECT_NAME_ARRAY[$d]} repo un archiving is successfull..!!! "
        	done
    	fi
}


#-------------------------------------------------------------Calling Main Function---------------------------------------------------------

main

#-------------------------------------------------------------------------------------------------------------------------------------------
