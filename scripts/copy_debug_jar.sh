#!/bin/sh

#script for development purpose to take the new JAR instead the JAr from S3


SOURCE="/source"
PATH_OF_JAR=$SOURCE/RnDTools/QualiX/guacamole-auth-quali/target
TMP_PATH=/tmp/guac
TAR_NAME=qualix-1.0.0.tar.gz
PACK_NAME=guacamole-auth-quali-1.0.0
JAR_NAME=$PACK_NAME".jar"
FULL_JAR_PATH=$PATH_OF_JAR/$JAR_NAME
DST_PATH=/development/NewQualixDocker/guacamole_image

if [ -d "$TMP_PATH" ];
then
    echo "Deleting temp dir"
    rm -rf $TMP_PATH
fi
mkdir $TMP_PATH
mkdir $TMP_PATH/$PACK_NAME

echo "Prepare Package..."
cp $FULL_JAR_PATH $TMP_PATH/$PACK_NAME
cp -R $PATH_OF_JAR/resources $TMP_PATH/$PACK_NAME
echo $1 >  $TMP_PATH/$PACK_NAME/version.txt

echo "Compressing path= $TMP_PATH/$PACK_NAME"
cd $TMP_PATH
tar -zcvf $TAR_NAME  $PACK_NAME
cd -

mv $TMP_PATH/$TAR_NAME $DST_PATH
