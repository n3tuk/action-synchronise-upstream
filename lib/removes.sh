#! /usr/bin/env bash

# Process the removes file to convert the JSON data for files into the format
# required to process requests
function get_removes {
  local file="${TEMPLATES}/${1}"

  if test -z "${file}"; then
    exit 0
  fi

  jq -c '.changes.removes[]' "${file}" 2> /dev/null
  exit ${?}
}

# Take an action and see if it's a request to remove a file, checking that it
# exists first
function do_remove {
  local action source

  action=${1}
  source=$(echo "${action}" | jq -r '.source')

  if [[ "${source}" != "null" && -e "${source}" ]]; then
    show_step "Removing '${source}'"
    git rm -f "${source}"
  fi
}
