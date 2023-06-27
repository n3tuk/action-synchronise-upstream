#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"

load "helpers/common"

setup() {
  set_environment_variables
}

@test "start_group() outputs correct format for GitHub Workflows" {
  source lib/common.sh
  run start_group test
  assert_output --partial "::group::test"
  assert_success
}

@test "end_group() outputs correct format for GitHub Workflows" {
  source lib/common.sh
  run end_group
  assert_output "::endgroup::"
  assert_success
}

@test "show_debug() outputs correct format for GitHub Workflows" {
  source lib/common.sh
  run show_debug test
  assert_output "::debug::test"
  assert_success
}

@test "show_error() outputs correct format for GitHub Workflows" {
  source lib/common.sh
  run show_error test
  assert_output "::error::test"
  assert_success
}

@test "exit_error() outputs correct format for GitHub Workflows with exit status" {
  source lib/common.sh
  run exit_error test
  assert_output "::error::test"
  assert_failure
}

@test "check_variable() successfully finds REPOSITORY variable" {
  refute_empty "${REPOSITORY}"
  source lib/common.sh
  run check_variable REPOSITORY
  assert_success
}

@test "check_variables() successfully finds BRANCH with other variables" {
  refute_empty "${REPOSITORY}"
  refute_empty "${BRANCH}"
  refute_empty "${TARGET}"
  source lib/common.sh
  run check_variables REPOSITORY BRANCH TARGET
  assert_success
}

@test "check_variable() fails on missing REPOSITORY variable" {
  unset REPOSITORY
  assert_empty "${REPOSITORY}"
  source lib/common.sh
  run check_variable REPOSITORY
  assert_output --partial "::error::"
  assert_output --partial "REPOSITORY"
  assert_failure
}

@test "check_variables() fails on missing TARGET variable among others" {
  unset TARGET
  refute_empty "${REPOSITORY}"
  refute_empty "${BRANCH}"
  assert_empty "${TARGET}"
  source lib/common.sh
  run check_variables REPOSITORY BRANCH TARGET
  assert_output --partial "::error::"
  assert_output --partial "TARGET"
  assert_failure
}

@test "check_command() successfully finds bash command" {
  source lib/common.sh
  run check_command bash
  assert_success
}

@test "check_commands() successfully finds bash and sh commands" {
  source lib/common.sh
  run check_commands bash sh
  assert_success
}

@test "check_command() fails on missing does-not-exist command" {
  source lib/common.sh
  run check_command does-not-exist
  assert_output --partial "::error::"
  assert_output --partial "does-not-exist"
  assert_failure
}

@test "check_commands() fails on missing does-not-exist command" {
  source lib/common.sh
  run check_commands bash sh does-not-exist
  assert_output --partial "::error::"
  assert_output --partial "does-not-exist"
  assert_failure
}
