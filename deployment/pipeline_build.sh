#!/bin/bash

DEPLOY_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTS_DIR="scripts"
cd $DEPLOY_SCRIPT_DIR

echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1


# expected env var:
# TMP_PATH - for tar file creation
# VERSION - for tar pacage version
# running the script: ./pipline_build.sh

# check env vars
VARS=(TMP_PATH VERSION)
for _var in "${VARS[@]}";
do
    echo "check if ${_var} exists"
    if [[ -z "${!_var}" ]]; then
        echoerr " enviroment var $_var doesnt exist"
        exit 1
    fi
done


# build Docker images
echo "Building docker images..."
./build_all.sh
docker images

# check docker images exists
cd ../scripts
./verify_build.sh
if [ $? -ne 0 ]; then
    echoerr "Docker build verification failed!"
    exit 1
fi

# test docker images
docker run --rm qualix_guacd echo "done"
docker run --rm qualix_guacamole echo "done"


# create TAR package to upload to S3
echo "Create TAR package..."
./create_tar_package.sh $TMP_PATH $VERSION
if [ $? -ne 0 ]; then
    echo "Tar package creation failed!"
    exit 1
fi

echok "Build Done!"

exit 0