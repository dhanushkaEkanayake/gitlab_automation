#!/bin/bash

GIT_API="your_api_url"
GIT_TOKEN="your_personel_access_token"
GROUP_ID="group_id"

total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&archived=false" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

echo -e  "${total_pages}"
