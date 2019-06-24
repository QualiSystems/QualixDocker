#!/bin/bash

#this script should not run except for development purpose. 
#script routine will run in TeamCity context 

# ARG1 - Version number for the docker image tag
# ARG2 - Version number for the JAR file.
# ARG3 - token from: https://travis-ci.com/profile   >> travis-ci project token

if [ "$1" != "" ]; then
    VERSION=$1
else
    VERSION=0.0.0
fi
if [ "$2" != "" ]; then
    JAR_VERSION=$2
else
    JAR_VERSION=0.0.0
fi
if [ "$3" != "" ]; then
    TOKEN=$3
else
    TOKEN="NONE"
fi
echo version is ${VERSION}

repo='QualiSystems%2FQualixDocker'

body='{
"request": {
    "branch":"master",
    "message": "Triggered by API for version '${VERSION}'",
    "config": {
        "env": {
            "version": "'${VERSION}'",
            "jar_version": "'${JAR_VERSION}'"
        }
    }
}}'
echo body is ${body}
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token ${TOKEN}" \
    -d "$body" \
    https://api.travis-ci.com/repo/$repo/requests
