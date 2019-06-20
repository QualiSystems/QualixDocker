#!/bin/bash

docker-compose down

total_instances=$(docker ps | grep quali | wc -l)
while [ "$total_instances" -ne "0" ]
do
    total_instances=$(docker ps | grep $STACK_NAME | wc -l)
    sleep 1
    printf .
done

echo $STACK_NAME containers removed!


