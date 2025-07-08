#!/usr/bin/bash

# SOURCE env vars
source .env

# POST: login
API_KEY=$(curl -ks --user "$USER:$PASS" https://$URL/authn/$ACCT/login)

# POST: auth
AUTH_Z=$(curl -ks --header "Accept-Encoding: base64" --data "$(echo $API_KEY)" https://$URL/authn/$ACCT/$USER/authenticate)

# Export both environment vars
export API_KEY
export AUTH_Z
