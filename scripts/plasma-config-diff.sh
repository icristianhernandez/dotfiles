#!/usr/bin/env bash
set -euo pipefail

CLEANUP_FILES=()

NAME="$(basename "$0")"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
BASE_FILE="$STATE_DIR/plasma-config-base.nix"
RC2NIX_CMD="nix run github:nix-community/plasma-manager"

mkdir -p "$STATE_DIR"

usage() {
	cat >&2 <<EOF
Usage: $NAME [command]

Commands:
  newbase    Capture current Plasma config as baseline
  show       Print current rc2nix output
  help       Show this help

  (no arg)   Diff current config against baseline
             (creates baseline automatically if missing)
EOF
	exit 0
}

check_plasma() {
	if ! pgrep -x plasmashell >/dev/null 2>&1; then
		echo "error: Plasma session not detected (plasmashell not running)" >&2
		exit 1
	fi
}

capture_config() {
	"$SHELL" -c "$RC2NIX_CMD" 2>/dev/null
}

cmd_newbase() {
	echo "Capturing Plasma config as baseline..." >&2
	capture_config >"$BASE_FILE"
	echo "Saved to $BASE_FILE" >&2
}

cmd_show() {
	capture_config
}

cmd_diff() {

	if [ ! -f "$BASE_FILE" ]; then
		echo "No baseline found -- creating one at $BASE_FILE" >&2
		cmd_newbase
		exit 0
	fi

	local tmp_current tmp_formatted_old tmp_formatted_new
	tmp_current="$(mktemp)"
	tmp_formatted_old="$(mktemp)"
	tmp_formatted_new="$(mktemp)"
	CLEANUP_FILES+=("$tmp_current" "$tmp_formatted_old" "$tmp_formatted_new")
	trap 'rm -f "${CLEANUP_FILES[@]}"' EXIT

	capture_config >"$tmp_current"

	if command -v nixfmt >/dev/null 2>&1; then
		nixfmt - <"$BASE_FILE" >"$tmp_formatted_old"
		nixfmt - <"$tmp_current" >"$tmp_formatted_new"
	else
		cat <"$BASE_FILE" >"$tmp_formatted_old"
		cat <"$tmp_current" >"$tmp_formatted_new"
	fi

	if diff --color=always -u "$tmp_formatted_old" "$tmp_formatted_new"; then
		echo "No changes detected" >&2
	fi
}

case "${1:-}" in
newbase) cmd_newbase ;;
show) cmd_show ;;
help | --help | -h) usage ;;
"") cmd_diff ;;
*)
	echo "error: Unknown command '$1'" >&2
	usage
	;;
esac
