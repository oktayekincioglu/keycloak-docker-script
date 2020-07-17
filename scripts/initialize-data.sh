#!/bin/bash
######################################################
#
#      Script: KeyCloak Initilization Script 
# Description: This script adds test realm/client/role 
#              and users to a clean KeyCloak instance
#
#      Author: Oktay Ekincioglu
#       Email: oktayekincioglu@gmail.com
#####################################################

pushd /opt/jboss/keycloak/bin/

function getClientId {
	response=$(./kcadm.sh get clients -r $1 --fields id,clientId)
	ar=($response)

	function findIdStr {
	    cnt=0; for el in "${ar[@]}"; do
		[[ $el == "$1" ]] && echo ${ar[cnt-3]} && break
		((++cnt))
	    done
	}

	a=$(findIdStr "\"$2\"")
	a=${a//','/''}
	a=${a//'"'/''}
	echo $a
}

HOST=127.0.0.1
PORT=8080
ADMIN_USERNAME='admin'
ADMIN_PASSWORD='admin'
REALM_NAME='test_realm'
CLIENT_NAME='test_client'
ROLE_NAME='test_role'
CLIENT_SECRET='d0b8122f-8dfb-46b7-b68a-f5cc4e25d000'

echo 'authenticating as admin...'
./kcadm.sh config credentials --server http://$HOST:$PORT/auth --realm master --user $ADMIN_USERNAME --password $ADMIN_PASSWORD

echo 'creating the realm - '$REALM_NAME
./kcadm.sh create realms -s realm=$REALM_NAME -s enabled=true

echo 'creating the client - '$CLIENT_NAME
./kcadm.sh create clients -r $REALM_NAME -s clientId=$CLIENT_NAME -s clientAuthenticatorType=client-secret -s secret=$CLIENT_SECRET -s directAccessGrantsEnabled=true

CID=$(getClientId $REALM_NAME $CLIENT_NAME)
echo $CID

echo 'creating the role - '$ROLE_NAME
./kcadm.sh create clients/$CID/roles -r $REALM_NAME -s name=$ROLE_NAME


username="james.bond"
echo 'creating a user - '$username

./kcadm.sh create users -r $REALM_NAME -s username=$username -s enabled=true
./kcadm.sh set-password -r $REALM_NAME --username=$username --new-password=password
./kcadm.sh add-roles -r $REALM_NAME --uusername $username --cclientid $CLIENT_NAME --rolename $ROLE_NAME
popd


