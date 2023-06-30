#! /usr/bin/env bash

set -euo pipefail

# Call GitHub and get the commit SHA value of the source branch we're going to
# use for the templates to render and apply over the top
function get_template_commit {
  gh api "/repos/${REPOSITORY}/branches/${BRANCH}" \
    --jq .commit.sha 2> /dev/null
  exit ${?}
}

# Merge all downstream values over the top of upstream as the base
# configuration, except for .changes.updates and .changes.removes which should
# be then taken from upstream override downstream (in effect a two-way merge)
function merge_cookiecutters {
  local upstream="${1}"
  local downstream="${2}"

  jq -s '.[0] * .[1] +
    { "changes":
      { "updates":.[0].changes.updates,
        "removes":.[0].changes.removes } }' \
    "${upstream}" \
    "${downstream}"
  return ${?}
}
