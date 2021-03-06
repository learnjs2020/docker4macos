#!/bin/bash

DOCKERCMD=$(command -v docker)

SCRIPTDIR=$(cd `dirname $0` && pwd)

ROOTPATH="$(dirname "$SCRIPTDIR")"
DATAPATH="$(dirname "$ROOTPATH")"/data

if [ $DOCKERCMD == '' ]; then
    echo "Error : Docker installation and running is required!"
    exit 0
fi



if [ $USER != $SUDO_USER ] && [ $USER == "root" ] ;
then

    rm -fr $DATAPATH/log

    docker network rm network_ui_app &> /dev/null
    docker stop container $(docker ps  -q -a --filter="name=local_admin_") &> /dev/null
    docker rm container $(docker ps  -q -a --filter="name=local_admin_") &> /dev/null

    docker stop container $(docker ps  -q -a --filter="name=local_proxy_") &> /dev/null
    docker rm container $(docker ps  -q -a --filter="name=local_proxy_") &> /dev/null

    docker stop container $(docker ps  -q -a --filter="name=local_sites_") &> /dev/null
    docker rm container $(docker ps  -q -a --filter="name=local_sites_") &> /dev/null

    docker system prune --all --force &> /dev/null

    rm -fr $DATAPATH/DOCKERCMD.json &> /dev/null
    
    sed '/echo _UI_APP/d' /var/at/tabs/$SUDO_USER  > /tmp/crontab_$SUDO_USER
    cp -f /tmp/crontab_$SUDO_USER  /var/at/tabs/$SUDO_USER
    rm -fr /tmp/crontab_$SUDO_USER 

    echo "Success : removed all applications"
else
    echo "Error : Need sudo run the command!"
fi