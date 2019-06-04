#!/bin/bash

echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1
echo()( echo $@|sed $'s,.*,\e[33m&\e[m,'>&2)3>&1

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
NAME=moshe_name

if [ -z "$VERSION" ]
then
    VERSION=1.0.0
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


# Tagging the images
QUACD_TAG=$DOCKER_USERNAME/$QUACD:$VERSION
GIACAMOLE_TAG=$DOCKER_USERNAME/$GIACAMOLE:$VERSION

docker tag $BASE_REPO/$QUACD:latest $QUACD_TAG
docker tag $BASE_REPO/$GIACAMOLE:latest $GIACAMOLE_TAG


# Login to Docker
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

