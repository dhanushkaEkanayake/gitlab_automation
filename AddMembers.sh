#! /bin/bash

GIT_API="https://git.zone24x7.lk/api/v4"
GIT_TOKEN="bVJ9jFDovV6vUEg-UmCt"
GROUP_ID="1079"


readarray -t USER_ID_ARRAY <1079_userID.txt

readarray -t USER_ACCESS_LEVEL_ARRAY <1079_userAccessLevel.txt

#echo "${USER_ID_ARRAY[1]}"

for (( d=0; d<${#USER_ID_ARRAY[@]}; d++ ))
do
	curl --request POST --header "PRIVATE-TOKEN: ${GIT_TOKEN}" \
     		--data "user_id=${USER_ID_ARRAY[$d]}&access_level=${USER_ACCESS_LEVEL_ARRAY[$d]}" "${GIT_API}/groups/${GROUP_ID}/members"
done
