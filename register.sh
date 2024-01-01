#!/usr/bin/env bash
set -x
BASE_COMMAND=$(cat /etc/systemd/system/matrix-synapse.service | grep "ExecStart=" | sed 's/.*ExecStart=//' |  sed 's/ .*//')
CONFIG_PATH=$(cat /etc/systemd/system/matrix-synapse.service | grep -A1 "ExecStart=" | tail -n1 |  sed 's/.*--config-path //' | sed 's/ .*//' )
REGISTER_COMMAND=$(dirname "$BASE_COMMAND")/register_new_matrix_user

"$REGISTER_COMMAND" -c "$CONFIG_PATH"
