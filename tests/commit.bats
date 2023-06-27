#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"

load "helpers/common"

setup() {
  set_environment_variables commit
  set_test_files {a,b}
}

teardown() {
  clean_test_files
}
