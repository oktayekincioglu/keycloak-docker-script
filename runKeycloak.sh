#!/bin/bash
#################################################
#
#      Script: KeyCloak docker starter script 
# Description: This script starts an KeyCloak instance 
#              and initializes test realm/client/users etc.
#
#      Author: Oktay Ekincioglu
#       Email: oktayekincioglu@gmail.com
#################################################

docker-compose up -d
container=$(docker-compose ps -q keycloak)
echo $container
timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8080)" != "200" ]]; do sleep 5; done' || false
docker exec -it $container bash /opt/kcinit/initialize-data.sh

