#!/bin/bash

PROD_PATH=/opt/qualix

if [ "$1" == "dev" ]; then
    STACK_FILE=docker-compose.dev.yml
else
    source ${PROD_PATH}/.env
    STACK_FILE=${PROD_PATH}/docker-compose.yml
fi

echo "Running from file: $STACK_FILE"



docker-compose -f $STACK_FILE $STACK_NAME up

echo
sleep 3
total_instances=$(docker ps | grep qualix_ | wc -l)
if [ "$total_instances" -ne "2" ];
then
    echo  $STACK_NAME containers Failed to start
    exit 1
fi

echo $STACK_NAME containers deployed!

echo -----------------------------------------
quacamole_id=$(docker ps | grep  qualix_guacamole | awk '{print $1}')
quacd_id=$(docker ps | grep  qualix_guacd | awk '{print $1}')
echo get logs of quacamole: docker logs -f $quacamole_id
echo get logs of guacd: docker logs -f $quacd_id
echo
echo "attach shell to quacamole:  docker exec -it $quacamole_id /bin/sh -c \"[ -e /bin/bash ] && /bin/bash || /bin/sh\""
echo "attach shell to quacd:  docker exec -it $quacd_id /bin/sh -c \"[ -e /bin/bash ] && /bin/bash || /bin/sh\""
echo -----------------------------------------

exit 0
