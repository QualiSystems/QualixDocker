#!/bin/bash

if [[ -z $VERSION ]]; then
    echo -e "\033[31mVERSION is not defined" >&2
    exit 1
fi
JAR_VERSION=$(echo $VERSION|cut -d '.' -f 1,2,3)
echo Build $VERSION
docker build --build-arg JAR_VERSION=$JAR_VERSION --build-arg BUILD_VERSION=$VERSION -t qualix_guacamole .

