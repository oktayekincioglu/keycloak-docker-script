# keycloak-docker-script
Starts a keycloak instance and creates test realm, client, role, users etc.

To start a keycloak instance, just run **./runKeycloak.sh**. Then make a token request immediately! 

![postman-token-request](postman-token-request.png)

curl --location --request POST 'localhost:8080/auth/realms/test_realm/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=test_client' \
--data-urlencode 'client_secret=d0b8122f-8dfb-46b7-b68a-f5cc4e25d000' \
--data-urlencode 'username=james.bond' \
--data-urlencode 'password=password'
