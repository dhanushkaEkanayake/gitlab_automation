GIT_API="your_api_url"
GIT_TOKEN="your_personel_access_token"
GROUP_ID="group_id"

for (( e=0; e<150; e++ ))
do
        curl\
                --request POST\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects?name=Project${e}&namespace_id=${GROUP_ID}"

done
