#!/bin/bash

######################################################
#
# env var required: VERSION >> for example '3.1.0.143'
# env var required: SOURCE_HUB >> for example 'qualitesthub'
# run the script for example: ./pull.sh
#
######################################################


echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1

function setError {
    echoerr "Pulling $1 image Failed! please check $1 log"
}

function done_pull {
    echok "Pulling images succeeded"
}

function pull {
    IMAGE=$1
    echok "pulling $IMAGE..."
    docker image pull $IMAGE
    if [ $? -ne 0 ]; then
        setError $IMAGE
        exit 1
    fi
}

QUACD=qualix_guacd
GUACAMOLE=qualix_guacamole

pull $SOURCE_HUB/$QUACD:$VERSION
pull $SOURCE_HUB/$GUACAMOLE:$VERSION

done_pull
#exit 0
