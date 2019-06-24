#!/bin/bash
docker build --build-arg JAR_VERSION=$jar_version -t qualix_guacamole .

