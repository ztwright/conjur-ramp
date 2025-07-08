#!/usr/bin/bash

# Source env vars from .env, authenticate.sh
source .env
. ./authenticate.sh

# POST set the websvadmin account creds
curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data "websvadmin" https://$URL/secrets/$ACCT/variable/LOB%2Fvault%2Fhashi-jwt-safe%2Fwebsvadmin%2Fusername
curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data "someSuperSecretPwd12!" https://$URL/secrets/$ACCT/variable/LOB%2Fvault%2Fhashi-jwt-safe%2Fwebsvadmin%2Fpassword
