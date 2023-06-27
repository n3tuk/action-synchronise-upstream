#! /usr/bin/env bash

# Process the updates file to convert the JSON data for files into the format
# required to process requests
function get_updates {
  local file="${TEMPLATES}/${1}"

  if test -z "${file}"; then
    exit 0
  fi

  jq -c '.changes.updates[]' "${file}" 2> /dev/null
  exit ${?}
}

# Take an action and see if it's a request to move a file, checking that it can
# be safely made first, and ensuring the destination exists beforehand as well
function do_move {
  local action source destination

  action=${1}
  source=$(echo "${action}" | jq -r '.source')

  if [[ "${source}" != "null" && -e "${source}" ]]; then
    destination=$(echo "${action}" | jq -r '.destination')
    if [[ "${destination}" == "null" || -e "${destination}" ]]; then
      show_step "Unable to move '${source}' to '${destination}'"
      exit 0
    fi
    show_step "Moving '${source}' to '${destination}'"
    # Make sure that the destination directory exists first
    mkdir -p "$(dirname "${destination}")"
    git mv "${source}" "${destination}"
  fi
}
