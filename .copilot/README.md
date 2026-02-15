# GitHub Copilot CLI Configuration

This directory contains configuration for GitHub Copilot CLI, mirroring the OpenCode configuration where possible.

## Overview

GitHub Copilot CLI uses a different configuration approach than OpenCode:
- **OpenCode**: Comprehensive JSON config file (`opencode/opencode.json`)
- **Copilot CLI**: Command-line flags + minimal `config.json`

## Configuration Comparison

### What CAN be mirrored from OpenCode

| OpenCode Feature | Copilot CLI Equivalent | Implementation |
|-----------------|----------------------|----------------|
| Model selection | `--model` flag or config.json | Command-line flag |
| Bash command permissions | `--allow-tool`, `--deny-tool` flags | Command-line flags |
| Path permissions | `--allow-all-paths`, `--add-dir` flags | Command-line flags |
| URL permissions | `--allow-url`, `--deny-url` flags | Command-line flags |
| Agent selection | `--agent` flag | Command-line flag |
| Custom instructions | `.github/copilot-instructions.md` | Markdown files |
| Custom agents | `.github/agents/*.md` | Markdown files |

### What CANNOT be directly mirrored

| OpenCode Feature | Limitation |
|-----------------|------------|
| TUI settings (scroll_speed, acceleration) | Not configurable in Copilot CLI |
| Keybinds customization | Fixed keybinds in Copilot CLI |
| Per-agent permission granularity | No per-agent config in Copilot CLI |
| Tool-specific permissions (grep, glob, etc.) | Not granularly controllable |
| File pattern permissions (*.env) | Not pattern-based |

## Recommended Usage

### For interactive sessions

Create a shell alias or function in your shell config:

```bash
# ~/.bashrc or ~/.zshrc
alias copilot-build='copilot \
  --allow-tool bash \
  --allow-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-url github.com'

alias copilot-plan='copilot \
  --agent plan \
  --deny-tool edit'
```

### For non-interactive mode

Use command-line flags directly:

```bash
copilot --prompt "Fix the bug in src/app.js" \
  --allow-all-tools \
  --allow-all-paths
```

## Files in this directory

- `README.md` - This file
- `config.json` - Minimal configuration file (structure undocumented)
- `mcp-config.json` - MCP server configuration

## References

- [Copilot CLI Documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli)
- [CLI Command Reference](https://docs.github.com/en/copilot/reference/cli-command-reference)
- OpenCode config: `../opencode/opencode.json`
