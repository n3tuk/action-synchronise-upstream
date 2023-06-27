#!/usr/bin/env bats

# Provide a helper function which at runtime overrides the GitHub CLI (gh)
# application so we do not need to make external calls when testing and can rely
# on consistent data for processing inputs and outputs as needed

function gh {
  case "${@}" in
    "api /repos/n3tuk/template-terraform-module/branches/main --jq .commit.sha")
      echo "8dff86f8afc08892a39ad0b44a0331e72ffdf4eb"
      ;;
  esac

  exit 0
}
