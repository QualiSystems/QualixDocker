#!/bin/bash

########################################################################################
# this script create tart file with all the relevant files to run the docker container
# the script guacamole-quali-install-docker.sh will install this tar on the relevant host

# file parameter
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ "$1" != "" ]; then
    TMP_PATH=$1
else
    TMP_PATH=/tmp/qualix_tar
fi

if [ "$1" != "" ]; then
    VERSION=$2
else
    VERSION=0.0.1
fi



TAR_NAME=qualix-docker-${VERSION}.tar
TAR_PATH=${TMP_PATH}/$TAR_NAME
GZ_PATH=${TAR_PATH}.gz
ENV_FILE=.env

echo "Starting Tar process..."
if [ -d "$TMP_PATH" ];
then
    echo "Deleting temp dir"
    rm -rf $TMP_PATH
fi
mkdir $TMP_PATH

#create tar file
tar cvf $TAR_PATH --files-from /dev/null
echo "tar file created!"
FILES=(docker-compose.yml start.sh stop.sh status.sh ${ENV_FILE})

cd $DIR

# Create versions env file
echo "TAG_GUACAMOLE=${VERSION}" > ${ENV_FILE}
echo "TAG_GUACD=${VERSION}" >> ${ENV_FILE}

# add files to tar file
for _file in "${FILES[@]}";
do
    echo Adding file "$_file" to tar file
    tar rvf $TAR_PATH $_file
    if [[ $? -ne 0 ]]; then
        echo "Failed to add ${_file} to archive file"
        exit 1
    fi
done
cd -

total_files=$(tar -tf $TAR_PATH | wc -l)
echo "the tar file contains $total_files files"

echo "Compressing file"
gzip -f $TAR_PATH

is_created=$(ls -l | grep $TAR_NAME | grep gz | wc -l)
if [ "$is_created"=="1" ];
then
    echo "File $GZ_PATH is ready"  
else
    echo "File compression failed!"
    exit 1
fi


exit 0

