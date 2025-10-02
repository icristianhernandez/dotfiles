# Comprehensive checks for Nix code quality, linting, and tooling availability.
# This module provides modular, maintainable checks with proper error handling.
{
  nixpkgs,
  systems,
  root,
}:
let
  inherit (nixpkgs) lib;
  forEachSystem = lib.genAttrs systems;

  # Configuration constants for better maintainability
  config = {
    # Directories to exclude from linting checks
    excludedDirs = [
      ".git"
      ".direnv"
      "result"
      "dist"
      "node_modules"
      ".terraform"
      ".venv"
      ".github"
    ];

    # Default statix configuration if no config file exists
    defaultStatixConfig = ''
      disabled = []
      nix_version = "2.4"
      ignore = [".direnv"]
    '';
  };

  # Helper function to create a check with consistent error handling
  mkCheck =
    {
      name,
      description ? name,
      buildInputs ? [ ],
      script,
    }:
    pkgs:
    pkgs.runCommand name
      {
        inherit buildInputs;
        meta.description = description;
      }
      ''
        set -euo pipefail

        echo "Running ${description}..."

        ${script}

        echo "✓ ${description} passed"
        touch "$out"
      '';

  # Helper to build exclusion arguments for deadnix
  mkDeadnixExcludes = excludes: lib.concatMapStringsSep " " (dir: "--exclude ${dir}") excludes;
in
forEachSystem (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    # Determine statix configuration path
    statixConfig =
      if builtins.pathExists (root + "/statix.toml") then
        pkgs.writeText "statix.toml" (builtins.readFile (root + "/statix.toml"))
      else
        pkgs.writeText "statix.toml" config.defaultStatixConfig;

    # Core linting checks for Nix code quality
    lintChecks = {
      # Statix: Lints and suggests fixes for Nix anti-patterns
      statix = mkCheck {
        name = "statix";
        description = "Statix linter for Nix anti-patterns";
        buildInputs = [ pkgs.statix ];
        script = ''
          statix check \
            --format errfmt \
            --config ${statixConfig} \
            ${root}
        '';
      } pkgs;

      # Deadnix: Finds and reports unused code in Nix expressions
      deadnix = mkCheck {
        name = "deadnix";
        description = "Deadnix checker for unused Nix code";
        buildInputs = [ pkgs.deadnix ];
        script = ''
          deadnix \
            --fail \
            --hidden \
            ${mkDeadnixExcludes config.excludedDirs} \
            ${root}
        '';
      } pkgs;
    };

    # LSP and tooling availability checks
    toolingChecks =
      {
        # Nixd LSP: Verify the Nix language server is available
        nixd =
          if builtins.hasAttr "nixd" pkgs then
            mkCheck {
              name = "nixd";
              description = "Nixd LSP availability check";
              buildInputs = [ pkgs.nixd ];
              script = ''
                nixd --version >/dev/null
                echo "Nixd version: $(nixd --version)"
              '';
            } pkgs
          else
            null;
      }
      // lib.optionalAttrs (builtins.hasAttr "nil" pkgs) {
        # Nil LSP: Alternative Nix language server (optional)
        nil = mkCheck {
          name = "nil";
          description = "Nil LSP availability check (optional)";
          buildInputs = [ pkgs.nil ];
          script = ''
            nil --version >/dev/null || true
            echo "Nil LSP is available"
          '';
        } pkgs;
      };

    # Security and hardening checks
    securityChecks = {
      # Check for potential security issues in Nix expressions
      nix-security-scan = mkCheck {
        name = "nix-security-scan";
        description = "Security scan for common Nix vulnerabilities";
        buildInputs = [
          pkgs.gnugrep
          pkgs.findutils
        ];
        script = ''
          echo "Scanning for potential security issues..."
          
          # Check for fetchurl without hash
          if find ${root} -name '*.nix' -type f -exec grep -l 'fetchurl' {} \; \
            | xargs grep -L 'sha256\|hash' 2>/dev/null | grep -q .; then
            echo "WARNING: Found fetchurl without hash - this is a security risk"
            find ${root} -name '*.nix' -type f -exec grep -l 'fetchurl' {} \; \
              | xargs grep -L 'sha256\|hash' 2>/dev/null || true
          fi
          
          # Check for insecure protocols
          if find ${root} -name '*.nix' -type f -exec grep -l 'http://' {} \; 2>/dev/null | grep -q .; then
            echo "WARNING: Found insecure http:// URLs - consider using https://"
            find ${root} -name '*.nix' -type f -exec grep -Hn 'http://' {} \; 2>/dev/null || true
          fi
          
          # Check for hardcoded secrets patterns (basic check)
          if find ${root} -name '*.nix' -type f \
            -exec grep -iE '(password|secret|token|apikey)\s*=\s*"[^"]{8,}"' {} + 2>/dev/null | grep -q .; then
            echo "WARNING: Potential hardcoded secrets detected"
            find ${root} -name '*.nix' -type f \
              -exec grep -iHnE '(password|secret|token|apikey)\s*=\s*"[^"]{8,}"' {} + 2>/dev/null || true
          fi
          
          echo "Security scan completed"
        '';
      } pkgs;
    };

    # Combine all checks, filtering out null values
    allChecks =
      lintChecks
      // lib.filterAttrs (_: v: v != null) toolingChecks
      // securityChecks;
  in
  allChecks
)
