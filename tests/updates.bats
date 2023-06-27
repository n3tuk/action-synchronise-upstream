#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"

load "helpers/common"
load "helpers/mkdir"
load "helpers/git"

setup() {
  set_environment_variables updates
  set_test_files {a,b,z}
}

teardown() {
  clean_test_files
}

@test "get_updates() processes update requests" {
  source lib/common.sh
  source lib/updates.sh
  run get_updates cookiecutter.json
  assert_line '{"source":"a.txt","destination":"b.txt"}'
  assert_line '{"source":"b.txt","destination":"c.txt"}'
  assert_success
}

@test "get_updates() handles empty requests cleanly" {
  source lib/common.sh
  source lib/updates.sh
  run get_updates empty.json
  refute_output --partial 'jq: error'
  refute_output --partial '{'
  assert_success
}

@test "get_updates() handles empty file cleanly" {
  source lib/common.sh
  source lib/updates.sh
  run get_updates blank.json
  refute_output --partial 'jq: error'
  refute_output --partial '{'
  assert_success
}

@test "do_move() handles valid move" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{"source":"b.txt","destination":"c.txt"}'
  assert_output --partial "Moving 'b.txt' to 'c.txt'"
  assert_success
}

@test "do_move() skips invalid move" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{"source":"a.txt","destination":"b.txt"}'
  refute_output --partial "Moving 'a.txt' to 'b.txt'"
  assert_output --partial "Unable to move 'a.txt' to 'b.txt'"
  assert_success
}

@test "do_move() skips completed move" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{"source":"y.txt","destination":"z.txt"}'
  refute_output --partial "Moving 'y.txt' to 'z.txt'"
  assert_success
}

@test "do_move() skips on missing destination" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{"source":"a.txt"}'
  refute_output --partial "Moving 'a.txt' to 'null'"
  assert_output --partial "Unable to move 'a.txt' to 'null'"
  assert_success
}

@test "do_move() skips on missing source" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{"destination":"b.txt"}'
  refute_output --partial "Moving 'null' to 'b.txt'"
  refute_output --partial "Unable to move 'null' to 'b.txt'"
  assert_success
}

@test "do_move() ignores empty action" {
  source lib/common.sh
  source lib/updates.sh
  run do_move '{}'
  refute_output --partial "Moving 'null' to 'null'"
  refute_output --partial "Unable to move 'null' to 'null'"
  assert_success
}
