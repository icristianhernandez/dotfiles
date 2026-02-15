# Quick Start Guide

This guide provides the fastest way to use GitHub Copilot CLI with OpenCode-equivalent settings.

## Prerequisites

Install GitHub Copilot CLI:
```bash
# Follow instructions at:
# https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli
```

## Quick Usage

### Method 1: Use the Wrapper Script (Recommended)

```bash
# Build mode (allows edits)
./.copilot/copilot-wrapper.sh build

# Plan mode (no edits)
./.copilot/copilot-wrapper.sh plan
```

### Method 2: Shell Aliases

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Build agent (mirrors opencode build agent)
alias ghc-build='copilot \
  --model "github-copilot/gpt-5-mini" \
  --allow-tool bash \
  --allow-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls \
  --experimental'

# Plan agent (mirrors opencode plan agent)
alias ghc-plan='copilot \
  --model "github-copilot/gpt-5-mini" \
  --agent plan \
  --deny-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls \
  --experimental'
```

Then use:
```bash
ghc-build  # Start in build mode
ghc-plan   # Start in plan mode
```

### Method 3: Direct Command

```bash
# Build mode
copilot --model "github-copilot/gpt-5-mini" --allow-tool bash --allow-tool edit --allow-all-urls

# Plan mode
copilot --agent plan --deny-tool edit --allow-all-urls
```

## Common Commands

```bash
# Include a file in your prompt
@path/to/file.txt

# Run shell command directly
!git status

# Delegate to GitHub Copilot agent
/delegate complete the API tests

# Change directory
/cd /path/to/project

# Add trusted directory
/add-dir /path/to/directory

# Review changes
/review

# Show usage stats
/usage
```

## Important Notes

1. **Interactive Approval**: Even with `--allow-tool bash`, Copilot will ask before running potentially dangerous commands
2. **No Pattern Matching**: Unlike OpenCode, you can't specify patterns like `"git status": "allow"` and `"*git push*": "deny"`
3. **Directory-based Permissions**: File access is controlled by directories, not file patterns
4. **Session-based**: Permissions are per-session, not saved globally

## Comparison with OpenCode

| Feature | OpenCode | Copilot CLI |
|---------|----------|-------------|
| Start command | `opencode` | `copilot` or `.copilot/copilot-wrapper.sh build` |
| Config location | `opencode/opencode.json` | Command-line flags |
| Agent switching | Configured in JSON | Use `--agent` flag or wrapper script |
| Edit permissions | Per-agent in JSON | `--allow-tool edit` or `--deny-tool edit` |
| Bash commands | Granular pattern matching | Binary allow/deny + interactive approval |

## Further Reading

- **Detailed mapping**: See `.copilot/MAPPING.md`
- **Complete findings**: See `.copilot/FINDINGS.md`
- **Overview**: See `.copilot/README.md`

## Support

For issues or questions:
1. Check the official [Copilot CLI documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli)
2. Run `copilot help` for built-in help
3. Use `/feedback` in Copilot CLI to submit feedback to GitHub
