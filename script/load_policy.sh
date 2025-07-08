#!/usr/bin/bash

# POST login/auth for AUTH_Z token
. ./authenticate.sh

# Source env vars
source .env

# POST: dry-run load policy
curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
  --header "Content-Type: text-plain" \
  --data "$(cat ../$POLICY_F)" \
  https://$URL/policies/$ACCT/policy/root?dryRun=true > out

# IF valid YAML, load it; ELSE exit code 1
if [[ $(cat out) == *"Valid YAML"* ]]; then
    curl -ks --header "Authorization: Token token=\"$AUTH_Z\"" \
      --header "Content-Type: text-plain" \
      --data "$(cat ../$POLICY_F)" \
      https://$URL/policies/$ACCT/policy/root
    rm -f out
    exit 0
else
    echo "YAML is invalid... exiting..."
    rm -f out
    exit 1
fi

