#!/usr/bin/bash

# Source env vars from .env, authenticate.sh
source .env
. ./authenticate.sh

# POST set the resource definition values
curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data "workflow" https://$URL/secrets/$ACCT/variable/conjur%2Fauthn-jwt%2F$SERVICE_ID%2Ftoken-app-property

curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data "apps/github" https://$URL/secrets/$ACCT/variable/conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fidentity-path

curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data "https://token.actions.githubusercontent.com" https://$URL/secrets/$ACCT/variable/conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fissuer

curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --data  "{\"type\":\"jwks\", \"value\":$PUBLIC_KEYS}" https://$URL/secrets/$ACCT/variable/conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fpublic-keys

#curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
#  --data "workflow,repository" https://$URL/secrets/$ACCT/variable/conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fenforced-claims

COUNTER=0
check_var() {
  local path=$1
  echo "Checking value of $path..."
  response=$(curl -ks --request GET --header "Authorization: Token token=\"$AUTH_Z\"" \
    "https://$URL/secrets/$ACCT/variable/$path")
  echo -e "Value:\t$response"
  if [[ "$response" == *"empty or not found"* ]]; then
    COUNTER=$((COUNTER+1))
  fi
  echo "============"
}

check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Ftoken-app-property"
check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fidentity-path"
check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fissuer"
check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fpublic-keys"
#check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fenforced-claims"
# Uncomment below line to test input validation for invalid data path
#check_var "conjur%2Fauthn-jwt%2F$SERVICE_ID%2Fnot-real"

echo "Total unset or missing variables: $COUNTER"
if [[ $COUNTER -gt 0 ]]; then
  echo "Something went wrong... check config..."
  exit 1
else
  echo "All resources in definition set appropriately..."
  sleep 2
  echo "Now enabling authenticator..."
  # Uncomment below to enable
  curl -kvvv --request PATCH --header "Authorization: Token token=\"$AUTH_Z\"" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data enabled\=true \
    https://$URL/authn-jwt/$SERVICE_ID/$ACCT
    exit 0
fi
