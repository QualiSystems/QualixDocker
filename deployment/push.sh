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

BASE_REPO=quali
QUACD=qualix_guacd
GIACAMOLE=qualix_guacamole
VERSION=1.0.0
TAG=moshe_tag
NAME=moshe_name
REPO=qualitesthub

# Tagging the images
QUACD_TAG=$REPO/$QUACD:$VERSION
GIACAMOLE_TAG=$REPO/$GIACAMOLE:$VERSION

docker tag $BASE_REPO/$QUACD:latest $REPO/$QUACD:$VERSION
docker tag $BASE_REPO/$GIACAMOLE:latest $REPO/$GIACAMOLE:$VERSION


# Login to Docker
if [ -z "$DOCKER_USERNAME" ]
then
    DOCKER_USERNAME=qualitesthub
fi
if [ -z "$DOCKER_PASSWORD" ]
then
    DOCKER_PASSWORD=12345678
fi
echo Login to docker hub with username: $DOCKER_USERNAME
docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echoerr failed to Login to docker hub repo
    exit 1
fi

# pushing the images
push $QUACD_TAG
push $GIACAMOLE_TAG


done_push
exit 0 

