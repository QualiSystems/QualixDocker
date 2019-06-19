#!/bin/bash

STACK_NAME=qualix
docker stack rm $STACK_NAME


total_instances=$(docker ps | grep $STACK_NAME | wc -l)
while [ "$total_instances" -ne "0" ]
do
    total_instances=$(docker ps | grep $STACK_NAME | wc -l)
    sleep 1
    printf .
done

echo $STACK_NAME stack removed!


