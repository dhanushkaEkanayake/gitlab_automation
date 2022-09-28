#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"   #replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"    #replace with your personal access token

for (( c=1154; c<1254; c++ ))  #no.of projects to be delete / ex:- 150
do
	 curl\
		--request DELETE\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects/${c}"
done
