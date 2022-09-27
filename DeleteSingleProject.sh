#!/bin/bash

GIT_API="http://gitlab.serverlab.com/api/v4"	#replace with your api url
GIT_TOKEN="glpat-MLCucPiBYG9TWZhToa9Z"	#replace with your personal access token     

	curl\
                --request DELETE\
                --header "PRIVATE-TOKEN: $GIT_TOKEN" "$GIT_API/projects/4"
