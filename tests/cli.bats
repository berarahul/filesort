#!/usr/bin/env bats

@test "filesort runs and prints help" {
  run ./filesort.sh help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "FileSort CLI" ]]
}

@test "filesort version" {
  run ./filesort.sh version
  [ "$status" -eq 0 ]
  [[ "$output" =~ "FileSort version" ]]
}
