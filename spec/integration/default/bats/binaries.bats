#!/usr/bin/env bats

@test "curl binary is found in PATH" {
  run which curl
  [ "$status" -eq 0 ]
}

@test "vim binary is found in PATH" {
  run which vim
  [ "$status" -eq 0 ]
}

@test "htop binary is found in PATH" {
  run which htop
  [ "$status" -eq 0 ]
}

@test "tmux binary is found in PATH" {
  run which tmux
  [ "$status" -eq 0 ]
}
