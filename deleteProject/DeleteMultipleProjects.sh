#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"   #replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_ID="12"    #replace with desired group ID


	total_pages=$(curl -s -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&archived=false" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')


	for (( d=1; d<=${total_pages};   d++ ))
	do
    		#------Retrieve the project IDs and names which in unarchive state for the given group
		PROJECT_ID_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&page=${d}&archived=false" | jq -r '.[] .id'))
        	PROJECT_NAME_ARRAY+=($(curl -sS --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&archived=false&per_page=100&page=${d}" | jq -r '.[] .name'))
	done



	if [ -z "${PROJECT_ID_ARRAY}"  ]; #-------Check whether are there any projects to be deleted or not
	then
		echo -e "There are no Repos to delete"
		exit 0
	else
    
    		echo -e "\nThere are ${#PROJECT_ID_ARRAY[@]} repos to be deleted\n"
    
		for (( d=0; d<${#PROJECT_ID_ARRAY[@]}; d++ ))
        	do
        		curl --silent --output /dev/null --request DELETE --header "PRIVATE-TOKEN: $GIT_TOKEN" -g "$GIT_API/projects/${PROJECT_ID_ARRAY[$d]}"
            		echo -e " ${PROJECT_NAME_ARRAY[$d]} repo deleting is successfull..!!! "
        	done
    	fi
