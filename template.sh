#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function error_handler() {
  echo ""
  echo "***************************************"
  echo "Error occurred in script at line: ${1}."
  echo "Line exited with status: ${2}"
  echo "***************************************"
  echo ""
}

log() {
  local level
  level=$1
  shift
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $level: $@"
}

info() {
  log INFO $@
}

err() {
  log ERROR $@ >&2
}

trap 'error_handler ${LINENO} $?' ERR

set -o errexit
set -o errtrace
set -o nounset

info "I'm good"

info "script_dir = ${script_dir}"

err "I'm an error log message"

test 1 -eq 0
