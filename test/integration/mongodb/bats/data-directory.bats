#!/usr/bin/env bats

@test "data directory exists" {
  run ls /mnt/data-store/mongodb/data
  [ "$status" -eq 0 ]
}
