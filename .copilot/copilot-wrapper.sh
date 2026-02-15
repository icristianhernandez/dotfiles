#!/usr/bin/env bash
# GitHub Copilot CLI wrapper with OpenCode-equivalent configuration
#
# This script mirrors the permissions and settings from opencode/opencode.json
# to GitHub Copilot CLI command-line flags.
#
# Usage:
#   ./copilot-wrapper.sh [build|plan] [additional copilot args...]

set -euo pipefail

AGENT="${1:-}"
shift || true

# Common flags mirroring opencode.json settings
COMMON_FLAGS=(
    # Model configuration
    --model "github-copilot/gpt-5-mini"
    
    # Path permissions
    --add-dir "$HOME"
    
    # Allowed tools from opencode.json
    --allow-tool bash
    --allow-tool grep
    --allow-tool glob
    --allow-tool web_fetch
    
    # Allowed URLs
    --allow-url github.com
    --allow-url githubusercontent.com
    
    # Enable experimental features
    --experimental
)

# Build agent specific flags
BUILD_FLAGS=(
    --allow-tool edit
    --allow-tool create
    --allow-tool view
)

# Plan agent specific flags (deny edit)
PLAN_FLAGS=(
    --deny-tool edit
)

case "$AGENT" in
    build)
        echo "Starting Copilot CLI in BUILD mode (mirroring opencode build agent)..."
        exec copilot "${COMMON_FLAGS[@]}" "${BUILD_FLAGS[@]}" "$@"
        ;;
    plan)
        echo "Starting Copilot CLI in PLAN mode (mirroring opencode plan agent)..."
        exec copilot "${COMMON_FLAGS[@]}" "${PLAN_FLAGS[@]}" --agent plan "$@"
        ;;
    *)
        echo "Usage: $0 [build|plan] [additional copilot args...]"
        echo ""
        echo "Modes:"
        echo "  build - Mirrors opencode 'build' agent (allows edits)"
        echo "  plan  - Mirrors opencode 'plan' agent (denies edits)"
        echo ""
        echo "This script applies OpenCode configuration to Copilot CLI."
        exit 1
        ;;
esac
