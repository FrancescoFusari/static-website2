#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5dfa7f9935ec380019408cdb/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dfa7f9935ec380019408cdb 
fi
curl -s -X POST https://api.stackbit.com/project/5dfa7f9935ec380019408cdb/webhook/build/ssgbuild > /dev/null
hugo
./inject-netlify-identity-widget.js public
curl -s -X POST https://api.stackbit.com/project/5dfa7f9935ec380019408cdb/webhook/build/publish > /dev/null
