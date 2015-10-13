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

trap 'error_handler ${LINENO} $?' ERR

set -o errexit
set -o errtrace
set -o nounset

echo "I'm good"

echo "script_dir = ${script_dir}"

test 1 -eq 0
