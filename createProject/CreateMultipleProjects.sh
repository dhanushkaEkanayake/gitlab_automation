#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_NAME="test_one"    #replace with desired group name


main(){

	getGroupID
	createProjects

}


getGroupID() {

	#-----To get the no of group result pages
	total_pages=$(curl -sS -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups?owned=true&top_level_only=true&per_page=100" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')
    
    
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



createProjects(){

	for (( e=0; e<10; e++ ))  #no.of new projects required
	do
        	curl -sS \
                	--request POST\
                	--header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects?name=Project${e}&namespace_id=${GROUP_ID}"

	done
}


main
