# OpenCode vs Copilot CLI - Side-by-Side Comparison

This document provides a visual side-by-side comparison of starting OpenCode vs Copilot CLI with equivalent settings.

## Starting a Session

### OpenCode
```bash
# Automatic - reads opencode/opencode.json
opencode
```

### Copilot CLI - Option 1: Wrapper Script
```bash
# Build mode (allows edits)
./.copilot/copilot-wrapper.sh build

# Plan mode (denies edits)  
./.copilot/copilot-wrapper.sh plan
```

### Copilot CLI - Option 2: Direct Command
```bash
# Build mode
copilot \
  --model "github-copilot/gpt-5-mini" \
  --allow-tool bash \
  --allow-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls \
  --experimental

# Plan mode
copilot \
  --model "github-copilot/gpt-5-mini" \
  --agent plan \
  --deny-tool edit \
  --allow-tool grep \
  --allow-tool glob \
  --allow-all-urls \
  --experimental
```

## Configuration Files

### OpenCode
```
opencode/
├── opencode.json              # Main config (140 lines)
└── opencode-jsonc-generator.py
```

### Copilot CLI
```
.copilot/
├── README.md                  # Overview
├── QUICKSTART.md              # Quick reference
├── MAPPING.md                 # Detailed mapping
├── FINDINGS.md                # Analysis
├── COMPARISON.md              # This file
├── config.json                # Minimal config
└── copilot-wrapper.sh         # Launcher script
```

## Feature Comparison Table

| Feature | OpenCode | Copilot CLI | Match? |
|---------|----------|-------------|--------|
| **Configuration** |
| Config file | ✅ opencode.json | ⚠️ Minimal config.json | Partial |
| Model selection | ✅ In config | ✅ CLI flag | ✅ |
| Default agent | ✅ In config | ✅ CLI flag | ✅ |
| **UI/UX** |
| Scroll speed | ✅ Configurable | ❌ Fixed | ❌ |
| Scroll acceleration | ✅ Configurable | ❌ Fixed | ❌ |
| Custom keybinds | ✅ ctrl+u, ctrl+d | ❌ Fixed | ❌ |
| **Permissions** |
| Tool permissions | ✅ Per-tool | ✅ Per-tool | ✅ |
| Bash command patterns | ✅ Granular | ❌ Binary | ❌ |
| File pattern permissions | ✅ *.env rules | ❌ Directory-based | ❌ |
| URL permissions | ✅ Per-domain | ✅ Per-domain | ✅ |
| Path permissions | ✅ Directory | ✅ Directory | ✅ |
| **Agents** |
| Custom agents | ✅ In config | ✅ Markdown files | ✅ |
| Per-agent permissions | ✅ Separate configs | ⚠️ Different CLI calls | Partial |
| Agent switching | ✅ Runtime | ✅ Runtime | ✅ |
| **Safety** |
| Deny git push | ✅ Pattern match | ⚠️ Interactive approval | Partial |
| Deny .env reading | ✅ Pattern match | ⚠️ Interactive approval | Partial |
| Approve on demand | ✅ Per pattern | ✅ Per command | ✅ |

Legend:
- ✅ Full support
- ⚠️ Partial support / workaround exists
- ❌ Not supported

## Example Workflows

### OpenCode: Git status and diff
```bash
# In OpenCode session
> run git status and show me the diff

# Config allows these automatically:
# "git status": "allow"
# "git diff": "allow"
```

### Copilot CLI: Git status and diff
```bash
# In Copilot session
> run git status and show me the diff

# With --allow-tool bash, Copilot still asks:
# "Run: git status? [Yes/No/Yes for session]"
# User: "Yes for session"
# Then git diff runs automatically
```

## Permission Granularity

### OpenCode: Fine-grained
```json
{
  "bash": {
    "*": "ask",                    // Ask by default
    "git status": "allow",         // Allow this exactly
    "git diff": "allow",           // Allow this exactly
    "nix run ./nixos#ci": "allow", // Allow this exactly
    "*git push*": "deny",          // Deny any push command
    "*git commit*": "deny"         // Deny any commit command
  }
}
```

### Copilot CLI: Coarse-grained
```bash
# Only binary choices:
--allow-tool bash   # Allow ALL bash commands (with interactive approval)
--deny-tool bash    # Deny ALL bash commands
```

**Safety note**: Even with `--allow-tool bash`, Copilot CLI uses heuristics to detect potentially dangerous commands and will ask for approval.

## Model Configuration

### OpenCode
```json
{
  "model": "github-copilot/gpt-5-mini",
  "small_model": "github-copilot/grok-code-fast-1"
}
```

### Copilot CLI
```bash
--model "github-copilot/gpt-5-mini"
# No small_model concept - single model per session
```

## Practical Impact

### What you lose moving from OpenCode to Copilot CLI:
1. ❌ Convenient single config file
2. ❌ Per-command bash permissions  
3. ❌ File pattern permissions (*.env)
4. ❌ UI customization (scroll, keybinds)
5. ❌ Per-agent permission profiles in one place

### What you gain:
1. ✅ Official GitHub support
2. ✅ Integration with GitHub features
3. ✅ MCP server support
4. ✅ Active development

### What stays the same:
1. ✅ Interactive approval system
2. ✅ Tool-level permissions
3. ✅ URL/domain permissions
4. ✅ Custom agents support
5. ✅ Model selection

## Recommendation

**For OpenCode users switching to Copilot CLI:**

1. Use the wrapper script for convenience:
   ```bash
   ln -s /path/to/dotfiles/.copilot/copilot-wrapper.sh ~/bin/copilot-build
   ln -s /path/to/dotfiles/.copilot/copilot-wrapper.sh ~/bin/copilot-plan
   ```

2. Trust the interactive approval system for safety

3. Create shell aliases for common invocations

4. Accept that some conveniences (fine-grained permissions, UI config) are not available

5. Leverage Copilot CLI's unique features (GitHub integration, MCP servers)
