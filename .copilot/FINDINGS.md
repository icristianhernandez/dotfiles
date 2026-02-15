# GitHub Copilot CLI Configuration Exploration - Findings

## Objective

Explore the possibility to create a GitHub Copilot CLI config file that mirrors the configuration defined in `opencode/opencode.json`.

## Executive Summary

**Conclusion**: GitHub Copilot CLI **cannot fully mirror** the OpenCode configuration through a config file. However, **most functionality can be replicated** using command-line flags and shell aliases.

### Key Limitations

1. **No comprehensive config file format**: Copilot CLI's `config.json` structure is undocumented and appears to be minimal
2. **Configuration via CLI flags**: Most settings must be passed as command-line arguments
3. **No granular permission patterns**: Cannot specify per-command bash permissions or file pattern-based permissions
4. **No UI customization**: TUI settings and keybinds are not configurable

## Detailed Findings

### 1. Configuration File Support

**OpenCode**: 
- Single comprehensive JSON file: `opencode/opencode.json`
- Contains models, TUI settings, keybinds, agent permissions, and granular tool permissions

**Copilot CLI**:
- Basic `~/.copilot/config.json` exists but format is undocumented
- Primary configuration through command-line flags
- MCP server config in `~/.copilot/mcp-config.json`

### 2. What CAN Be Replicated

| Feature | OpenCode | Copilot CLI Method | Coverage |
|---------|----------|-------------------|----------|
| Model selection | ✅ | `--model` flag | Full |
| Agent selection | ✅ | `--agent` flag | Full |
| Tool permissions | ✅ | `--allow-tool`, `--deny-tool` | Partial |
| URL permissions | ✅ | `--allow-url`, `--deny-url` | Full |
| Directory access | ✅ | `--add-dir` flag | Full |
| Custom instructions | ✅ | `.github/copilot-instructions.md` | Full |
| Custom agents | ✅ | `.github/agents/*.md` | Full |

### 3. What CANNOT Be Replicated

| Feature | Reason |
|---------|--------|
| TUI settings (scroll speed, etc.) | Not configurable in Copilot CLI |
| Custom keybinds | Fixed in Copilot CLI |
| Granular bash command permissions | No pattern matching support |
| File pattern permissions (*.env) | No pattern matching support |
| Per-agent permission differences | No centralized agent config |
| Small model configuration | Not supported |

### 4. Permission System Comparison

#### OpenCode: Granular Pattern-Based
```json
{
  "bash": {
    "*": "ask",
    "git status": "allow",
    "git diff": "allow",
    "*git push*": "deny",
    "*git commit*": "deny"
  }
}
```

#### Copilot CLI: Binary Tool-Based
```bash
# Can only allow or deny entire tools
--allow-tool bash   # Allows ALL bash commands
--deny-tool bash    # Denies ALL bash commands
```

**Safety Note**: Copilot CLI compensates with interactive approval - it asks before running potentially dangerous commands even when bash tool is allowed.

## Deliverables

### 1. Documentation
- `/.copilot/README.md` - Overview and usage guide
- `/.copilot/MAPPING.md` - Detailed feature mapping
- `/.copilot/FINDINGS.md` - This document

### 2. Configuration Files
- `/.copilot/config.json` - Basic config file (structure inferred)
- `/.copilot/copilot-wrapper.sh` - Shell script to replicate agent behaviors

### 3. Wrapper Script Usage

```bash
# Build mode (allows edits)
./.copilot/copilot-wrapper.sh build

# Plan mode (denies edits)
./.copilot/copilot-wrapper.sh plan
```

The wrapper script translates OpenCode agent permissions to Copilot CLI flags.

## Recommendations

### For Day-to-Day Use

**Option 1: Shell Aliases** (Recommended)
Add to `~/.bashrc` or `~/.zshrc`:
```bash
alias ghc-build='copilot --allow-tool bash --allow-tool edit --allow-all-urls'
alias ghc-plan='copilot --agent plan --deny-tool edit --allow-all-urls'
```

**Option 2: Use the Wrapper Script**
```bash
# Create symlink for easier access
ln -s .copilot/copilot-wrapper.sh ~/bin/copilot-build
ln -s .copilot/copilot-wrapper.sh ~/bin/copilot-plan
```

**Option 3: Environment Variables**
```bash
export COPILOT_ALLOW_ALL=1  # Less safe, but equivalent to --allow-all
```

### For Team Sharing

Use custom instructions and custom agents:
1. Create `.github/copilot-instructions.md` for repository-wide guidance
2. Create `.github/agents/*.md` for custom agent profiles
3. Share the wrapper script in the repository

## Limitations and Trade-offs

### Security Considerations

**OpenCode Advantage**:
- Fine-grained control over specific commands
- Pattern-based file protection (*.env files)
- Per-agent permission differences

**Copilot CLI Reality**:
- Coarser control (tool-level, not command-level)
- No pattern-based file protection
- Interactive approval provides safety net

**Mitigation**: 
- Rely on Copilot CLI's interactive approval system
- Use `--deny-tool` for tools you never want to use
- Manually review commands before approval

### Workflow Impact

**OpenCode**:
- Start once with full config loaded
- Consistent behavior across sessions

**Copilot CLI**:
- Must specify flags on each invocation OR
- Use shell aliases/wrapper scripts for consistency

## Testing Status

⚠️ **Cannot test without Copilot CLI installed**

The configuration has been created based on:
- Official GitHub Copilot CLI documentation
- Command reference documentation
- Analysis of OpenCode configuration structure

To test:
1. Install GitHub Copilot CLI
2. Run: `.copilot/copilot-wrapper.sh build`
3. Verify permissions match OpenCode behavior
4. Adjust flags as needed based on actual behavior

## References

1. [GitHub Copilot CLI Documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli)
2. [CLI Command Reference](https://docs.github.com/en/copilot/reference/cli-command-reference)
3. OpenCode configuration: `opencode/opencode.json`

## Conclusion

While GitHub Copilot CLI cannot use a comprehensive config file like OpenCode, the **functionality can be adequately replicated** using:
- Command-line flags for permissions
- Shell aliases for convenience
- Custom instructions for context
- Interactive approval for safety

The main limitations are in fine-grained permission control and UI customization, not in core functionality.
