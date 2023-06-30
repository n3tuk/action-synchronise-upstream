#! /usr/bin/env bash

set -euo pipefail

function get_template_commit {
  gh api "/repos/${REPOSITORY}/branches/${BRANCH}" \
    --jq .commit.sha 2> /dev/null
  exit ${?}
}
