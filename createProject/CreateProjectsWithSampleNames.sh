#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_ID="12"    #replace with desired group ID

	readarray -t name < sampleProjectNames.txt

	for i in ${name[@]}
	do
        	curl --stderr  -sS --request POST --header "PRIVATE-TOKEN: $GIT_TOKEN" \
			"$GIT_API/projects?name=${i}&namespace_id=${GROUP_ID}"
	done
