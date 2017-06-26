#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

true_echo=$(which echo)

log() {
  local level
  level=$1
  shift
  $true_echo "[$(date +'%Y-%m-%dT%H:%M:%S.%3N%z')] $level: $@"
}

echo() {
  log INFO "$@"
}

info() {
  log INFO "$@"
}

err() {
  log ERROR "$@" >&2
}

function error_handler() {
  err ""
  err '***************************************'
  err "Error occurred in script at line: ${1}."
  err "Line exited with status: ${2}"
  err '***************************************'
  err ""
}

trap 'error_handler ${LINENO} $?' ERR

set -o errexit
set -o errtrace
set -o nounset

info "I'm good"

info "script_dir = ${script_dir}"

err "I'm an error log message"

test 1 -eq 0
