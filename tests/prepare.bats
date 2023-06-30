#!/usr/bin/env bats

bats_load_library "bats-support"
bats_load_library "bats-assert"
bats_load_library "bats-file"

load "helpers/common"
load "helpers/gh"

setup() {
  set_environment_variables prepare
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

@test "merge_cookiecutters() correctly two-way merges cookiecutter files" {
  source lib/common.sh
  source lib/prepare.sh
  run merge_cookiecutters \
    "${TEMPLATES}/upstream.json" \
    "${TEMPLATES}/downstream.json"

  assert_output --partial '"owner": "n3tuk"'
  # Prove this has not been overridden in the merge of downstream over upstream
  assert_output --partial '"name": "downstream"'
  # Prove these have been overridden in the merge of upstream over downstream
  assert_output --partial '"source": "c.txt"'
  assert_output --partial '"destination": "d.txt"'
  assert_output --partial '"source": "x.txt"'
  assert_output --partial '"source": "y.txt"'
  assert_output --partial '"source": "z.txt"'

  # Prove this has been overridden in the merge of downstream over upstream
  refute_output --partial '"name": "upstream"'
  # Prove these have been overridden in the merge of upstream over downstream
  refute_output --partial '"source": "a.txt"'
  refute_output --partial '"destination": "b.txt"'
  refute_output --partial '"source": "b.txt"'
  refute_output --partial '"destination": "c.txt"'

  assert_success
}
