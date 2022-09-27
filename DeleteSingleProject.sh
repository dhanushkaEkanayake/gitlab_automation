#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"
GROUP_ID="12"

for (( c=150; c<154; c++ ))  #no.of new projects required / ex:- 100
do
	 curl\
                --request DELETE\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects/${c}"
done
