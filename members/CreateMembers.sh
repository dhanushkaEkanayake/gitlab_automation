#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token

	readarray -t name < sampleMembersNames.txt
	readarray -t username < sampleUserNames.txt
	readarray -t email < sampleemails.txt

	for (( c=0; c<${#name[@]}; c++ ))
	do
		curl\
                	--request POST\
                	--header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/users?name=${name[c]}&username=${username[c]}&email=${email[c]}&reset_password=true"
	done
