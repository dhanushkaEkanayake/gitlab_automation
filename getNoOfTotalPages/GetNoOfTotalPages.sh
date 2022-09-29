#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token
GROUP_ID="12"	#replace with desired group ID

total_pages=$(curl -s -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&archived=false" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

echo -e  "${total_pages}"
