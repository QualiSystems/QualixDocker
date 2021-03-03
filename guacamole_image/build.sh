#!/bin/bash
S3_BUCKET_URL=https://quali-dev-binaries.s3.amazonaws.com
VERSION=$1
JAR_VERSION=$(echo $VERSION|cut -d '.' -f 1,2,3)
BUILD_VERSION=$VERSION
#if [ $jar_version ]; then
#    VERSION=$jar_version
#fi

#BUILD_VERSION=$(curl -s $S3_BUCKET_URL/?prefix=qualix-$VERSION|grep -o "qualix-$VERSION\.*[0-9]*.tar.gz"|sort -V|tail -n 1|grep -o "$VERSION\.\+[0-9]\+"||echo $VERSION)
echo Build $BUILD_VERSION
docker build --build-arg JAR_VERSION=$JAR_VERSION --build-arg BUILD_VERSION=$VERSION -t qualix_guacamole .

