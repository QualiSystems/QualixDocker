#!/bin/bash

######################################################
#
# env var reqiored: VERSION >> for example 1.4.0.123
# run the script for example: ./push.sh
#
######################################################


echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1

function setError {
    echoerr "Pushing $1 image Failed! please check $1 log"
}

function done_push {
    echok Pushing images succeeded
}

function push {
    IMAGE=$1
    docker image push $IMAGE
    if [ $? -ne 0 ]; then
        setError $IMAGE
        exit 1
    fi
}

function tag_image {
    IMAGE_ID=$1
    TAG=$2
    docker tag $IMAGE_ID $TAG
}

# build number for the image tag
VARS=(VERSION DOCKER_USERNAME DOCKER_PASSWORD)
for _var in "${VARS[@]}";
do
    echo "check if ${_var} exists"
    if [[ -z "${!_var}" ]]; then
        echoerr " enviroment var $_var doesnt exist"
        exit 1
    fi
done

echo Using build number: $VERSION

QUACD_BASE=qualix_guacd
GUACAMOLE_BASE=qualix_guacamole

if [[ -n "$SOURCE_HUB" ]]; then
    QUACD_ID=docker images $SOURCE_HUB/$QUACD_BASE -q
    GUACAMOLE_ID=docker images $SOURCE_HUB/$GUACAMOLE_BASE -q
else
    QUACD_ID=docker images QUACD_BASE -q
    GUACAMOLE_ID=docker images GUACAMOLE_BASE -q
fi

if [ -z "$DOCKER_USERNAME" ]
then
    echo "No Docker hub username detected"
    DOCKER_USERNAME=YourUserName
fi
if [ -z "$DOCKER_PASSWORD" ]
then
    echo "No Docker hub password detected"
    DOCKER_PASSWORD=YouPassword
fi

# Login to Docker
echo Login to docker hub with username: $DOCKER_USERNAME
docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echoerr failed to Login to docker hub repo
    docker logout
    exit 1
fi

# Tagging the images
tag_image $QUACD_ID $DOCKER_USERNAME/$QUACD_BASE:$VERSION
tag_image $QUACD_ID $DOCKER_USERNAME/$QUACD_BASE:latest
tag_image $GUACAMOLE_ID $DOCKER_USERNAME/$GUACAMOLE_BASE:$VERSION
tag_image $GUACAMOLE_ID $DOCKER_USERNAME/$GUACAMOLE_BASE:latest

# pushing the images
push $DOCKER_USERNAME/$QUACD_BASE
push $DOCKER_USERNAME/$GUACAMOLE_BASE

done_push
docker logout
exit 0 
