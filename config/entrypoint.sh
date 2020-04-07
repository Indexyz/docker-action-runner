#!/bin/sh
set -ex

export RUNNER_ALLOW_RUNASROOT=1

# Config GitHub Runner
/runner/config.sh --url "${RUNNER_REPO}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --work /runner/_work

/usr/bin/supervisord -c /etc/supervisord.conf -n
