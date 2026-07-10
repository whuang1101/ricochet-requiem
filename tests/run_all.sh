#!/bin/bash
set -u
cd "$(dirname "$0")/.."

run() {
  output="$(godot --headless --path . "$@" 2>&1)"
  printf '%s\n' "$output"
  if rg -q 'FAIL|SCRIPT ERROR|ERROR:' <<<"$output"; then
    exit 1
  fi
}

run --editor --quit
run --script res://tests/test_slug_physics.gd
