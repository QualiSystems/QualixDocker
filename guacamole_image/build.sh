#!/bin/bash
BUILD_VERSION=$1
if [[ -z $BUILD_VERSION ]]; then
    BUILD_VERSION=$VERSION
fi
JAR_VERSION=$(echo $BUILD_VERSION|cut -d '.' -f 1,2,3)
echo Build $BUILD_VERSION
docker build --build-arg JAR_VERSION=$JAR_VERSION --build-arg BUILD_VERSION=$BUILD_VERSION -t qualix_guacamole .

