#!/bin/sh

########################################################################################
# this script create tart file with all the relevant files to run the docker container
# the script guacamole-quali-install-docker.sh will install this tar on the relevant host

# file parameter
if [ "$1" != "" ]; then
    BUILD_NUMBER=$1
else
    BUILD_NUMBER=123
fi
TAR_NAME=qualix-docker.tar
TMP_PATH=${BUILD_NUMBER}
TAR_PATH=${TMP_PATH}/$TAR_NAME
GZ_PATH=${TAR_PATH}.gz

if [ -d "$TMP_PATH" ];
then
    echo "Deleting temp dir"
    rm -rf $TMP_PATH
fi
mkdir $TMP_PATH
#create tar file
tar cvf $TAR_PATH --files-from /dev/null

FILES=(docker-compose.yml start.sh stop.sh status.sh)

for _file in "${FILES[@]}";
do
    tar rvf $TAR_PATH "$_file"
done

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

