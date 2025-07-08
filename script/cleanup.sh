#!/usr/bin/bash

# POST login/auth for AUTH_Z token
. ./authenticate.sh

# Source env vars
source .env

# PATCH clean up resources
curl -ks --request PATCH --header "Authorization: Token token=\"$AUTH_Z\"" \
  --header "Content-Type: text-plain" \
  --data "$(cat ../delete.yml)" \
  https://$URL/policies/$ACCT/policy/root
