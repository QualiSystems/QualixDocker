#!/bin/bash

######################################################
#
# run the script for example: ./push.sh 1.0.2.33
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

# build number for the image tag
if [ "$1" != "" ]; then
    VERSION=$1
else
    echo "Version is required. please run the script with arg of version. for example: ./push.sh 1.0.2.33"
fi
echo Using build number: $VERSION

QUACD=qualix_guacd
GUACAMOLE=qualix_guacamole


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
GUACAMOLE_TAG_BASE=$DOCKER_USERNAME/$GUACAMOLE
GUACAMOLE_TAG=$GUACAMOLE_TAG_BASE:$VERSION
GUACAMOLE_TAG_LATEST=$GUACAMOLE_TAG_BASE:latest

docker tag $QUACD $QUACD_TAG
docker tag $QUACD $QUACD_TAG_LATEST
docker tag $GUACAMOLE $GUACAMOLE_TAG
docker tag $GUACAMOLE $GUACAMOLE_TAG_LATEST


# pushing the images
push $QUACD_TAG
push $QUACD_TAG_LATEST
push $GUACAMOLE_TAG
push $GUACAMOLE_TAG_LATEST


done_push
docker logout
exit 0 

