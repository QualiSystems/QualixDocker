#!/bin/bash

STACK_NAME=qualix
STACK_FILE=docker-compose.yml
docker stack deploy --compose-file $STACK_FILE $STACK_NAME

