#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"

load "helpers/common"
load "helpers/gh"

setup() {
  set_environment_variables
}

teardown() {
  true
}

@test "get_template_commit() returns the template commit SHA" {
  source lib/common.sh
  source lib/prepare.sh
  run get_template_commit
  assert_output "${COMMIT}"
  assert_success
}
