#!/usr/bin/env bash

APP_HOME=/home/app
CONFIG_DIR=${APP_HOME}/.soapuios/config

soapuiRun() {
  (
    (cp ${CONFIG_DIR}/* ${APP_HOME} 2>/dev/null || echo "No config files") && soapui
  ) ||
    exit 1
}

copyConfig() {
  # shellcheck disable=SC2046
  (cd ${APP_HOME} && cp $(ls ${CONFIG_DIR}) ${CONFIG_DIR} 2>/dev/null || echo "No config files") ||
    exit 1
}

firstCommand=$1
shift

case "${firstCommand}" in
run | "")
  soapuiRun "$@"
  ;;
copy)
  copyConfig "$@"
  ;;
*)
  echo "Commands: [run|copy]" >&2
  exit 1
  ;;
esac

exit 0
