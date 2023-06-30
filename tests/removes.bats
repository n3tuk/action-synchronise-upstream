#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"

load "helpers/common"
load "helpers/git"

setup() {
  set_environment_variables removes
  set_test_files {a,b}
}

teardown() {
  clean_test_files
}

@test "get_removes() processes removal requests" {
  source lib/common.sh
  source lib/removes.sh
  run get_removes cookiecutter.json
  assert_line '{"source":"a.txt"}'
  assert_line '{"source":"b.txt"}'
  assert_success
}

@test "get_removes() handles empty requests cleanly" {
  source lib/common.sh
  source lib/removes.sh
  run get_removes empty.json
  refute_output --partial 'jq: error'
  refute_output --partial '{'
  assert_success
}

@test "get_removes() handles empty file cleanly" {
  source lib/common.sh
  source lib/removes.sh
  run get_removes blank.json
  refute_output --partial 'jq: error'
  refute_output --partial '{'
  assert_success
}

@test "do_remove() handles valid removal" {
  source lib/common.sh
  source lib/removes.sh
  run do_remove '{"source":"a.txt"}'
  assert_output --partial "Removing 'a.txt'"
  assert_success
}

@test "do_remove() skips invalid removal" {
  source lib/common.sh
  source lib/removes.sh
  run do_remove '{"destination":"b.txt"}'
  refute_output --partial "Removing 'b.txt'"
  refute_output --partial "Removing 'null'"
  assert_success
}

@test "do_remove() skips completed removal" {
  source lib/common.sh
  source lib/removes.sh
  run do_remove '{"source":"c.txt"}'
  refute_output --partial "Removing 'c.txt'"
  assert_success
}

@test "do_remove() ignores empty action" {
  source lib/common.sh
  source lib/removes.sh
  run do_remove '{}'
  refute_output --partial "Removing 'null'"
  assert_success
}
