#!/bin/sh

########################################################################################
# this script create tart file with all the relevant files to run the docker container
# the script guacamole-quali-install-docker.sh will install this tar on the relevant host

# file parameter
if [ "$1" != "" ]; then
    TMP_PATH=$1
else
    TMP_PATH=/tmp/qualix_tar
fi
TAR_NAME=qualix-docker.tar
TAR_PATH=${TMP_PATH}/$TAR_NAME
GZ_PATH=${TAR_PATH}.gz

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
FILES=(docker-compose.yml start.sh stop.sh status.sh)

for _file in "${FILES[@]}";
do
    echo Adding file "$_file" to tar file
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

