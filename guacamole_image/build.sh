#!/bin/bash
S3_BUCKET_URL=https://quali-dev-binaries.s3.amazonaws.com
VERSION=3.2.0
if [ $jar_version ]; then
    VERSION=$jar_version
fi
BUILD_VERSION=$(curl -s $S3_BUCKET_URL/?prefix=qualix-$VERSION|grep -o "qualix-$VERSION\.*[0-9]*.tar.gz"|sort -V|tail -n 1|grep -o "$VERSION\.\+[0-9]\+"||echo $VERSION)
echo Build $BUILD_VERSION
docker build --build-arg JAR_VERSION=$VERSION --build-arg BUILD_VERSION=$BUILD_VERSION -t qualix_guacamole .

