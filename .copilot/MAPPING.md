# OpenCode to Copilot CLI Configuration Mapping

This document provides a detailed mapping between `opencode/opencode.json` configuration and GitHub Copilot CLI equivalents.

## Model Configuration

### OpenCode
```json
{
  "model": "github-copilot/gpt-5-mini",
  "small_model": "github-copilot/grok-code-fast-1"
}
```

### Copilot CLI Equivalent
```bash
copilot --model "github-copilot/gpt-5-mini"
```

**Limitation**: Copilot CLI doesn't have a concept of "small_model" for different operations.

## TUI Settings

### OpenCode
```json
{
  "tui": {
    "scroll_speed": 3,
    "scroll_acceleration": {
      "enabled": false
    }
  }
}
```

### Copilot CLI Equivalent
**NOT CONFIGURABLE** - Copilot CLI has fixed TUI behavior.

## Keybinds

### OpenCode
```json
{
  "keybinds": {
    "messages_half_page_up": "ctrl+u",
    "messages_half_page_down": "ctrl+d"
  }
}
```

### Copilot CLI Equivalent
**NOT CONFIGURABLE** - Copilot CLI has fixed keybinds. See [CLI Command Reference](https://docs.github.com/en/copilot/reference/cli-command-reference).

## Default Agent

### OpenCode
```json
{
  "default_agent": "plan"
}
```

### Copilot CLI Equivalent
```bash
copilot --agent plan
```

## Agent Permissions

### Common Permission Patterns

| OpenCode Permission | Copilot CLI Equivalent | Notes |
|-------------------|----------------------|-------|
| `"*": "ask"` | Default behavior | Copilot asks by default |
| `"*": "allow"` | `--allow-all` or `--yolo` | Allow everything |
| `"*": "deny"` | No direct equivalent | Must deny specific tools |
| `"external_directory": "ask"` | Default behavior | Asks for directory access |
| `"webfetch": "allow"` | `--allow-all-urls` or `--allow-url <domain>` | |
| `"task": "allow"` | Built-in, no flag needed | |
| `"codesearch": "allow"` | Built-in, no flag needed | |
| `"lsp": "allow"` | Built-in, no flag needed | |
| `"edit": "allow"` | `--allow-tool edit` | |
| `"edit": "deny"` | `--deny-tool edit` | |
| `"grep": "allow"` | `--allow-tool grep` | |
| `"glob": "allow"` | `--allow-tool glob` | |

### Build Agent Permissions

OpenCode config allows most tools for the build agent. Equivalent Copilot CLI command:

```bash
copilot \
  --allow-tool bash \
  --allow-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls
```

### Plan Agent Permissions

OpenCode config denies edit for the plan agent:

```bash
copilot \
  --agent plan \
  --deny-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls
```

## Bash Command Permissions

### OpenCode Granular Bash Permissions
```json
{
  "bash": {
    "*": "ask",
    "true": "allow",
    "nix run ./nixos#ci": "allow",
    "git status": "allow",
    "git diff": "allow",
    "*git push*": "deny",
    "*git commit*": "deny"
  }
}
```

### Copilot CLI Limitation
**NOT DIRECTLY MAPPABLE** - Copilot CLI doesn't support per-command bash permissions. You can only:
- `--allow-tool bash` - Allow all bash commands
- `--deny-tool bash` - Deny all bash commands

**Workaround**: Use Copilot's interactive approval system. It will ask before running commands.

## File Pattern Permissions

### OpenCode
```json
{
  "read": {
    "*": "allow",
    "*.env": "deny",
    "*.env.*": "deny",
    "*.env.example": "allow"
  }
}
```

### Copilot CLI Limitation
**NOT DIRECTLY MAPPABLE** - Copilot CLI doesn't support file pattern-based permissions. Path permissions are directory-based:
```bash
copilot --add-dir /path/to/allowed/directory
```

**Workaround**: Rely on interactive approval for sensitive files.

## Summary of Capabilities

### ✅ Can Mirror

1. Model selection
2. Basic tool permissions (allow/deny)
3. URL permissions
4. Agent selection
5. Directory access

### ❌ Cannot Mirror

1. TUI customization (scroll speed, acceleration)
2. Keybind customization
3. Granular bash command patterns
4. File pattern-based permissions
5. Per-agent permission differences
6. Small model configuration

### ⚠️ Partial Support

1. **Bash permissions**: No pattern matching, but interactive approval provides safety
2. **File permissions**: No pattern matching, but directory-based + interactive approval
3. **Agent-specific configs**: Must use different command invocations rather than centralized config

## Recommended Approach

Since Copilot CLI doesn't support a comprehensive config file like OpenCode, use **shell aliases** to replicate different agent behaviors:

```bash
# Add to ~/.bashrc or ~/.zshrc

# Build agent equivalent
alias ghc-build='copilot --allow-tool bash --allow-tool edit --allow-tool grep --allow-tool glob --allow-all-urls'

# Plan agent equivalent  
alias ghc-plan='copilot --agent plan --deny-tool edit --allow-tool grep --allow-tool glob --allow-all-urls'
```

Or use the provided `copilot-wrapper.sh` script:
```bash
./.copilot/copilot-wrapper.sh build
./.copilot/copilot-wrapper.sh plan
```
