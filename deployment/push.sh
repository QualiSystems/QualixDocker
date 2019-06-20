#!/bin/bash

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

# build number for the image tag
if [ "$1" != "" ]; then
    VERSION=$1
else
    VERSION=0.9.0
fi
echo Using build number: $VERSION

QUACD=qualix_guacd
GIACAMOLE=qualix_guacamole


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
QUACD_TAG_BASE=$DOCKER_USERNAME/$QUACD
QUACD_TAG=$QUACD_TAG_BASE:$VERSION
QUACD_TAG_LATEST=$QUACD_TAG_BASE:latest
GIACAMOLE_TAG_BASE=$DOCKER_USERNAME/$GIACAMOLE
GIACAMOLE_TAG=$GIACAMOLE_TAG_BASE:$VERSION
GIACAMOLE_TAG_LATEST=$GIACAMOLE_TAG_BASE:latest

docker tag $QUACD $QUACD_TAG
docker tag $QUACD $QUACD_TAG_LATEST
docker tag $GIACAMOLE $GIACAMOLE_TAG
docker tag $GIACAMOLE $GIACAMOLE_TAG_LATEST


# pushing the images
push $QUACD_TAG
push $QUACD_TAG_LATEST
push $GIACAMOLE_TAG
push $GIACAMOLE_TAG_LATEST


done_push
docker logout
exit 0 

