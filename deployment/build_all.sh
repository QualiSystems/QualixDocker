#!/bin/bash

EXEC_DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$EXEC_DIR" # go to ref dir

echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1

function setError {
    echoerr "Building $1 image Failed! please check $1 log"
}

STEP=guacamole
echo Building $STEP
cd ../guacamole_image

./build.sh| tee guacamole_image.log
if [ $? -ne 0 ]; then
    setError $IMAGE
    exit 1
fi
cd - > /dev/null 2>&1

STEP=quacd
echo Building $STEP
cd ../guacd_image
./build.sh| tee guacd_image.log
if [ $? -ne 0 ]; then
    setError $IMAGE
    exit 1
fi
cd - > /dev/null 2>&1

echok Building images succeeded
docker images | grep qual
exit 0
