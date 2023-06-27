#!/usr/bin/env bats

# Set up the standard environment variables which will normally be provied by
# the GitHub Action configuration
function set_environment_variables {
  export GITHUB_TOKEN # This should be set by the environment

  REPOSITORY="n3tuk/template-terraform-module"
  BRANCH="main"
  TARGET="main"
  PREFIX="chore/synchronise-upstream/"
  TITLE="Synchronise Upstream Template Changes"
  LABELS="dependencies,release/skip"
  export REPOSITORY BRANCH TARGET PREFIX TITLE LABELS

  # Additional environment variables for checks/testing
  TEMPLATES="${BATS_TEST_DIRNAME}/assets/${1:-common}"
  COMMIT="8dff86f8afc08892a39ad0b44a0331e72ffdf4eb"
  export TEMPLATES COMMIT
}

# Create the required files for validating testing of updates and removes
function set_test_files {
  for file in "${@}"; do
    touch "${file}.txt"
  done
}

# Remove the created files for validating testing of updates and removes
function clean_test_files {
  find . -maxdepth 1 -type f -name '?.txt' \
    | while read -r file; do
      rm "${file}"
    done
}

function assert_empty {
  assert [ -z "${1}" ]
}

function refute_empty {
  assert [ ! -z "${1}" ]
}
