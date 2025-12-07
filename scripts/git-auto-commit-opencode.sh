#!/usr/bin/env bash
set -euo pipefail

GENERATE_STAGE_COMMIT_PROMPT="You are a professional Git commit message writer. Read the staged diff from stdin, passed in the prompt. Produce ONE commit message that strictly follows Conventional Commits (types: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert). Output ONLY the commit message text — no commentary, no quotes, no code fences, no labels, no extra whitespace or blank lines. Format: type(scope?): short imperative summary (<=50 chars, no trailing period). Optionally include a body separated by a blank line, wrapped at 72 chars, and footers (BREAKING CHANGE: , Closes #NNN). When the body lists multiple changes, use bullet points prefixed with '- ' and start each with a concise area tag (e.g., 'deps:', 'editor:', 'experimental:') followed by a terse active-voice fragment; keep each bullet on one line when possible (<=72 chars) and include file/dir hints when it fits. Use 'chore' by default for dependency bumps, config tweaks, refactors, renames, or load-mode adjustments; use 'fix' only for clear runtime bug fixes. Choose a scope if a single file/dir is affected; otherwise omit scope. If the change is trivial (formatting, whitespace), prefer style/chore. If you cannot produce a suitable commit message, output an empty string."
# Can explore the models with: opencode models
OPENCODE_MODEL_FLAG="--model=github-copilot/grok-code-fast-1"

DEBUG_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/opencode"
DEBUG_COMMIT_MSG="${DEBUG_BASE}/commit-message.txt"
DEBUG_JSON="${DEBUG_BASE}/context.json"
DEBUG_DIFF_LOG="${DEBUG_BASE}/diff.txt"
DEBUG_STDERR="${DEBUG_BASE}/stderr.txt"
DEBUG_MODE=0

while [ "$#" -gt 0 ]; do
	case "$1" in
	# Modes: default auto-commit; enable --debug to generate logs only (no commit)
	-m | --model)
		if [ "$#" -lt 2 ]; then
			echo "error: --model requires an argument" >&2
			exit 1
		fi
		OPENCODE_MODEL_FLAG="--model=$2"
		shift 2
		;;
	--debug)
		DEBUG_MODE=1
		shift
		;;

	--)
		shift
		break
		;;
	-*)
		echo "error: Unknown option: $1" >&2
		exit 1
		;;
	*) break ;;
	esac
done

function ensure_opencode() {
	if ! command -v opencode >/dev/null 2>&1; then
		echo "error: opencode is not installed or not in PATH" >&2
		exit 1
	fi
}

function ensure_staged_changes() {
	if git diff --staged --quiet; then
		echo "error: No staged changes to commit. Closing script." >&2
		exit 1
	fi
}

function run_all_checks() {
	ensure_opencode
	ensure_staged_changes
}

function build_context() {
	printf 'FILES:\n'
	git diff --staged --name-status

	# Trying to rawdog commits without use base git conventions
	# printf '\nLAST_COMMIT:\n'
	# git log -1 --pretty=%B 2>/dev/null || true

	printf '\nPATCH:\n'
	git diff --staged --no-color -U3
}

echo "🤖 Generating commit message using OpenCode..."

function ensure_debug_dir() {
	mkdir -p "$DEBUG_BASE"
}

function generate_diff_debug() {
	ensure_debug_dir
	build_context >"$DEBUG_DIFF_LOG"
}

function run_opencode() {
	local format="$1"
	shift || true
	opencode run "$GENERATE_STAGE_COMMIT_PROMPT" "$OPENCODE_MODEL_FLAG" --file - --format "$format"
}

function generate_json_debug() {
	ensure_debug_dir
	build_context | run_opencode json >"$DEBUG_JSON" 2>"$DEBUG_STDERR"
}

function generate_last_response_debug() {
	ensure_debug_dir
	build_context | run_opencode default >"$DEBUG_COMMIT_MSG" 2>"$DEBUG_STDERR"
}

function run_all_debugs() {
	generate_diff_debug
	generate_json_debug
	generate_last_response_debug
}

function commit_with_pipeline() {
	if build_context | run_opencode default | git commit -F -; then
		return 0
	else
		local rc=$?
		echo "error: commit failed (exit $rc)" >&2
		return $rc
	fi
}

run_all_checks

if [ "$DEBUG_MODE" -eq 1 ]; then
	run_all_debugs

	echo "🤖 Debug finished — artifacts generated (XDG state):"
	echo "- $DEBUG_DIFF_LOG"
	echo "- $DEBUG_JSON"
	echo "- $DEBUG_COMMIT_MSG"
	echo "- $DEBUG_STDERR"
	echo "🤖 Debug files generated"
else
	if commit_with_pipeline; then
		COMMIT_HASH=$(git rev-parse --short HEAD)
		COMMIT_SUMMARY=$(git log -1 --pretty=%s)
		echo "🤖 Auto-commit finished — $COMMIT_HASH: $COMMIT_SUMMARY"
	else
		exit 1
	fi
fi

exit 0
