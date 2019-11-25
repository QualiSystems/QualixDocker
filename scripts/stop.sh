#!/bin/bash

#fix bug 173637 http://team:8080/tfs/Quali-Collection/QualiSystems/_workitems?id=173637&_a=edit
cd /opt/qualix

#this is done only to workaround this bug https://github.com/docker/compose/issues/6838
mv '.env' '.env_old'

docker-compose down

#the rest of the workaround
mv '.env_old' '.env'

total_instances=$(docker ps | grep quali | wc -l)
while [ "$total_instances" -ne "0" ]
do
    total_instances=$(docker ps | grep $STACK_NAME | wc -l)
    sleep 1
    printf .
done

echo $STACK_NAME containers removed!


