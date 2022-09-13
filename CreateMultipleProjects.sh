GIT_API="https://git.zone24x7.lk/api/v4"
GIT_TOKEN="bVJ9jFDovV6vUEg-UmCt"
GROUP_ID="1079"

for (( e=0; e<150; e++ ))
do
        curl\
                --request POST\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects?name=Project${e}&namespace_id=${GROUP_ID}"

done
