#!/bin/bash

GIT_API="https://git.zone24x7.lk/api/v4"
GIT_TOKEN="bVJ9jFDovV6vUEg-UmCt"
GROUP_ID="1079"

total_pages=$(curl -I --request GET --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/groups/$GROUP_ID/projects?include_subgroups=true&per_page=100&archived=false" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

echo -e  "${total_pages}"
