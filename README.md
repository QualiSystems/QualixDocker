[![Build Status](https://travis-ci.com/QualiSystems/QualixDocker.svg?branch=master)](https://travis-ci.com/QualiSystems/QualixDocker)

## Qualix

This Qualix solution is based on Docker technology.

To run Qualix under docker host, first, install docker engine on your host. you may find all the instructions  [on Docker website](https://docs.docker.com/install/)


<br>

### Production
To test end-to-end Qualix deployment on docker in production Environment, please download the [installation script](https://quali-prod-binaries.s3.amazonaws.com/guacamole-quali-install-docker.sh) and run it from clean Linux host.
 
After installation, you will have 3 scripts to manage the enviroment:
 1. *`qualix_start`* - start the containers stack
 2. *`qualix_stop`* - stop the containers
 3. *`qualix_status`* - check the status of the Qualix containers

You may get all the logs with:
get logs of quacamole: docker logs -f *<container_id>*                                                                                                                                                                                           

You may attach to shell with:                                                                                                                                                                                                                                                                                                                                                                                                                                          docker exec -it *<container_id>*/bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh" \
You may find more info in the help center:  [Qualix Getting Started](https://support.quali.com/hc/en-us/articles/231607307-QualiX-Getting-Started-Guide)

<br>

### Development
During development phase you may find most of the scripts unders `script` directory, and some of them under the `deployment` directory.
To build the images, run the script:

    ./deployment/build_all.sh
    
To push the images to docker-hub you can use the script:

    ./deployment/push.sh
   Be aware to develop all the scripts in Linux to avoid invalid charecters.
   


