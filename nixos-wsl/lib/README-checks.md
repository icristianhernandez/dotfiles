# Nix Checks Module

This module provides comprehensive checks for the NixOS-WSL dotfiles repository.

## Overview

The `checks.nix` module defines a set of automated checks that run via `nix flake check` to ensure code quality, security, and consistency.

## Check Categories

### Linting Checks

- **statix**: Lints Nix code for anti-patterns and suggests improvements
  - Configurable via `statix.toml` in the repository root
  - Uses `errfmt` for readable output
  
- **deadnix**: Detects unused code in Nix expressions
  - Runs in strict mode (`--fail`)
  - Checks hidden files (`--hidden`)
  - Excludes common build/cache directories

**Note**: Format checking has been intentionally excluded from automated checks as per repository policy. Use `nix fmt` locally to format code before committing.

### Tooling Checks

- **nixd**: Verifies the Nixd LSP is available (optional)
  - Only runs if `nixd` is available in nixpkgs
  - Displays version information

- **nil**: Verifies the Nil LSP is available (optional)
  - Alternative Nix language server
  - Only runs if `nil` is available in nixpkgs

### Security Checks

- **nix-security-scan**: Scans for common security issues
  - Detects `fetchurl` without hash (security risk)
  - Identifies insecure `http://` URLs
  - Checks for potential hardcoded secrets
  - Non-blocking warnings for review

## Configuration

### Excluded Directories

The following directories are excluded from checks:
- `.git` - Git repository data
- `.direnv` - Development environment cache
- `result` - Nix build output symlinks
- `dist` - Distribution builds
- `node_modules` - Node.js dependencies
- `.terraform` - Terraform state
- `.venv` - Python virtual environments
- `.github` - GitHub workflows and configuration

### Adding New Checks

To add a new check:

1. Define the check using the `mkCheck` helper function:
```nix
my-check = mkCheck {
  name = "my-check";
  description = "Description of what this checks";
  buildInputs = [ pkgs.my-tool ];
  script = ''
    my-tool --check ${root}
  '';
} pkgs;
```

2. Add it to the appropriate check category (`lintChecks`, `toolingChecks`, or `securityChecks`)

3. The check will automatically be included in `nix flake check`

## Running Checks

```bash
# Run all checks
nix flake check -L

# Run from the nixos-wsl directory
cd nixos-wsl
nix flake check -L
```

## Maintenance

- Keep `excludedDirs` up to date with new directories that should be ignored
- Update `defaultStatixConfig` if changing the statix baseline
- Review security check patterns periodically for new vulnerability types
- Consider check execution time when adding new checks

## Design Principles

1. **Modularity**: Each check is independent and reusable via `mkCheck`
2. **Consistency**: All checks use uniform error handling and output
3. **Documentation**: Inline comments explain each check's purpose
4. **Maintainability**: Configuration is centralized and easy to modify
5. **Hardening**: Security checks help identify potential vulnerabilities early
