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
run --script res://tests/test_tuning_resonance.gd
run --script res://tests/test_requiem.gd
run --script res://tests/test_room_flow.gd
run --script res://tests/test_deck_cards.gd
run --script res://tests/test_act1.gd
run --script res://tests/test_meta.gd
