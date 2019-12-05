#!/bin/bash
EXPECTED_BUILDS=4
results=$(docker ps | grep quali | wc -l)


if [ "$results" = "$EXPECTED_BUILDS" ];
then
    echo "Qualix containers up and running"
    exit 0
fi
echo "Qualix containers is down!"
exit 1

