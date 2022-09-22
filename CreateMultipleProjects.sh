#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"
GROUP_ID="12"

for (( e=0; e<150; e++ ))
do
        curl\
                --request POST\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects?name=Project${e}&namespace_id=${GROUP_ID}"

done
