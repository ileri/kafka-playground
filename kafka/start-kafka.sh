#!/bin/bash

set -euo pipefail

KAFKA_HOME=/opt/kafka
CONFIG_FILE=$KAFKA_HOME/config/server.properties

function envNameToConfigName() {
  env_name=$1
  echo "$env_name" | cut -d "_" -f2- | tr "_" "." | tr '[:upper:]' '[:lower:]'
}

function applyConfigs() {
  for variable in $(env); do
    key=$(echo "$variable" | cut -d "=" -f1)
    value=$(echo "$variable" | cut -d "=" -f2)
    if [[ $key =~ ^KAFKA_ ]]; then
      key_config_name=$(envNameToConfigName "$key")
      changeInConfigFile "$CONFIG_FILE" "$key_config_name" "$value"
    fi
  done
}

function changeInConfigFile() {
  file=$1
  key=$2
  value=$3

  if grep -qE "^$key=" "$file"; then
    sed -iE "s@^$key=.*@$key=$value@g" "$file"
  else
    echo "$key=$value" >> "$file"
  fi
}

applyConfigs
$KAFKA_HOME/bin/kafka-server-start.sh $CONFIG_FILE