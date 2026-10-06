#!/usr/bin/env bash
# Tests for tmux-bridge: read guard fingerprinting, target resolution.
# Runs on an isolated tmux server.
set -euo pipefail
BIN="$(cd "$(dirname "$0")/.." && pwd)/scripts/tmux-bridge"
fail(){ echo "FAIL: $1"; exit 1; }

SOCK="$(mktemp -u /tmp/tb-test-XXXXXX)"
export TMUX_BRIDGE_SOCKET="$SOCK"
export TMUX_BRIDGE_STATE="$(mktemp -d)"
unset TMUX 2>/dev/null || true

cleanup() {
  tmux -S "$SOCK" kill-server 2>/dev/null || true
  rm -rf "$TMUX_BRIDGE_STATE" "$SOCK"
}
trap cleanup EXIT

# Layout: session t1 window 0 = sender(%0) + neighbor(%1),
#         window 1 = other-window pane, session t2 = other-session pane.
tmux -S "$SOCK" new-session -d -s t1 -x 80 -y 24
tmux -S "$SOCK" split-window -h -t t1:0
tmux -S "$SOCK" new-window -t t1
tmux -S "$SOCK" new-session -d -s t2 -x 80 -y 24
panes_w0=($(tmux -S "$SOCK" list-panes -t t1:0 -F '#{pane_id}'))
SENDER="${panes_w0[0]}"; NEIGHBOR="${panes_w0[1]}"
OTHERWIN=$(tmux -S "$SOCK" list-panes -t t1:1 -F '#{pane_id}')
OTHERSESS=$(tmux -S "$SOCK" list-panes -t t2:0 -F '#{pane_id}')
export TMUX_PANE="$SENDER"
sleep 0.3  # let shells start

# --- read guard ---
"$BIN" type "$NEIGHBOR" "x" 2>/dev/null && fail "type without read succeeded" || true
"$BIN" read "$NEIGHBOR" 5 >/dev/null
"$BIN" type "$NEIGHBOR" "echo guard-ok" || fail "type after read failed"
"$BIN" type "$NEIGHBOR" "y" 2>/dev/null && fail "read mark not cleared after type" || true

# guard invalidated when pane process is replaced between read and act
"$BIN" read "$NEIGHBOR" 5 >/dev/null
tmux -S "$SOCK" respawn-pane -k -t "$NEIGHBOR"
sleep 0.3
"$BIN" type "$NEIGHBOR" "z" 2>/dev/null && fail "acted on replaced pane" || true

# --- target resolution ---
"$BIN" read 1 5 2>/dev/null && fail "bare window index accepted" || true

echo "PASS test_tmux_bridge"
