#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log() {
  local level
  level=$1
  shift
  echo "[$(date +'%Y-%m-%dT%H:%M:%S.%3N%z')] $level: $@"
}

stdout() {
  if [[ $# -eq 0 ]]
  then
    while read line
    do
      log INFO "$line"
    done
  else
    log INFO "$@"
  fi
}

stderr() {
  if [[ $# -eq 0 ]]
  then
    while read line
    do
      log ERROR "$line" >&2
    done
  else
    log ERROR "$@" >&2
  fi
}

err() {
  if [[ $# -eq 0 ]]
  then
    while read line
    do
      echo "$line" >&2
    done
  else
    echo "$@" >&2
  fi
}

this_script="${BASH_SOURCE[0]}"

# Clearer errors on bash failure
error_handler() {
  cat <<-EOF >&2
  ***************************************
  Error occurred in "${this_script} at line: ${1}.
  Line exited with status: ${2}
  $(cat -n "$this_script" | grep -e "^[ \t]*${1}\W")
  ***************************************
EOF
}

trap 'error_handler ${LINENO} $?' ERR

set -o errexit
set -o errtrace
set -o nounset

main() {
  echo "I'm a log message"
  err "I'm an error message"

  echo "I have $# args"

  for arg in "$@"
  do
    echo "arg: '$arg'"
  done

  echo "script_dir = ${script_dir}"

  test 1 -eq 0
}

{ main "$@" 2>&1 1>&3 3>&- | stderr; } 3>&1 1>&2 | stdout
