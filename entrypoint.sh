#!/bin/bash
TD_AGENT_CONFIG=td-agent.conf

# check if TD_AGENT_CONFIG_URL is provided
if [ -z "${TD_AGENT_CONFIG_URL}" ]; then
  echo "[*] TD_AGENT_CONFIG_URL is not set, use default configuration for fluentd"
else
  echo "[*] TD_AGENT_CONFIG_URL=[${TD_AGENT_CONFIG_URL}]"
  
  set +e
  /usr/bin/curl --retry 10 -o "$TD_AGENT_CONFIG" "$TD_AGENT_CONFIG_URL"
  RETVAL=$?
  set -e

  if [ "$RETVAL" -eq 0 ]; then
    echo "[*] td-agent.conf downloaded"
    /bin/cp "$TD_AGENT_CONFIG" /etc/td-agent/"$TD_AGENT_CONFIG"
  else
    echo "[*] failed to download td-agent.conf"
#   exit 1
  fi
fi

# start the td-agent
/usr/sbin/td-agent
