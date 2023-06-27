#! /usr/bin/env bash

set -euo pipefail

# Set up colours for improving output
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set common variables which should be available for multiple scripts
# shellcheck disable=SC2034 # these are used by scripts which source this file
IGNORE_FILE=".templateignore"

# Check to see if the variable name provided both exists and has a value
# associated with it, otherwise error and exit the script
function check_variables {
  for variable in "${@}"; do
    check_variable "${variable}"
  done
}
# Check to see if the variable name provided both exists and has a value
# associated with it, otherwise error and exit the script
function check_variable {
  set +u # Don't error out on unbound variables in this function
  if [[ -z "${!1}" ]]; then
    exit_error "Missing the environment variable '${1}'"
  fi
}

# Check to see if all the commands provided exists and are executable, otherwise
# error and exit the script
function check_commands {
  for command in "${@}"; do
    check_command "${command}"
  done
}

# Check to see if the command provided both exists and is executable, otherwise
# error and exit the script
function check_command {
  if [[ ! -x "$(command -v "${1}")" ]]; then
    exit_error "Missing the ${1} application. Please install and try again."
  fi
}

# Initiate the starting of a grouped output for GitHub Actions
function start_group {
  echo "::group::${1}"
  show_stage "${1}"
}

# End the grouped output section for GitHub Actions
function end_group {
  echo "::endgroup::"
}

# Output a debug message for GitHub Actions
function show_debug {
  echo "::debug::${1}"
}

# Output the header for a new stage in the application
function show_stage {
  echo -e "${YELLOW}==>${NC} ${WHITE}${1}${NC}"
}

# Output the message for a step in the application
function show_step {
  echo -e " ${BLUE}->${NC} ${WHITE}${1}${NC}"
}

# Define an output in the GitHub Action for GitHub Workflows
function put_output {
  echo "${1}=${2}" >> "${GITHUB_OUTPUT}"
}

# Output an error message for GitHub Actions
function show_error {
  echo "::error::${1}"
}

# Output an error message for GitHub Actions and then immediately exit the
# script
function exit_error {
  show_error "${1}"
  exit 1
}
