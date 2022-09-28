#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4" 	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_ID="12"    #replace with desired group ID

for (( e=0; e<100; e++ ))  #no.of new projects required
do
        curl\
                --request POST\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects?name=Project${e}&namespace_id=${GROUP_ID}"

done
