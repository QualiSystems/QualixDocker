#!/bin/bash

set -e

docker pull qualitesthub/qualix_guacamole:$VERSION
docker pull qualitesthub/qualix_guacd:$VERSION

echo "logging in to the production account with user" $PROD_HUB_USER
docker login -u $PROD_HUB_USER -p $PROD_HUB_PWD

guacamole_id=$(docker images qualitesthub/qualix_guacamole:$VERSION -q)
echo "qualix_guacamole:$VERSION id - $guacamole_id"

echo "tagging qualihub/qualix_guacamole with 'latest' and '$VERSION'"
docker tag $guacamole_id qualihub/qualix_guacamole:latest
docker tag $guacamole_id qualihub/qualix_guacamole:$VERSION
echo "pushing qualix_guacamole"
docker push qualihub/qualix_guacamole

guacd_id=$(docker images qualitesthub/qualix_guacd:$VERSION -q)
echo "qualix_guacd:$VERSION id - $guacd_id"

echo "tagging qualihub/qualix_guacd with 'latest' and '$VERSION'"
docker tag $guacd_id qualihub/qualix_guacd:latest
docker tag $guacd_id qualihub/qualix_guacd:$VERSION

echo "pushing qualix_guacd to qualihub"
docker push qualihub/qualix_guacd

echo "Done"
exit 0