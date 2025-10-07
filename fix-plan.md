# NixOS Config Fix Plan (./nixos/**)

Goal: Resolve confirmed, real issues impacting correctness, portability, security, and maintainability of the NixOS subconfig. Keep changes minimal, explicit, and aligned with repo conventions. Do not touch lock files. Validate with `nix run ./nixos#ci` after each phase.

## Scope confirmation (validated against code)
- Real bugs/portability
  - `nixos/apps/nixos-lint.nix` looks for `nixos/statix.toml`; actual `statix.toml` is at repo root. Needs fix.
  - `nixos/home-modules/nvim.nix` uses `mkOutOfStoreSymlink` to `${const.dotfiles_dir}/nvim/.config/nvim` (user/repo hardcoded). Should reference the flake tree, not a home path.
- Security/over-broad defaults
  - `nixos/home-modules/ssh-agent.nix`: `AddKeysToAgent yes` under `Host *`; redundant `matchBlocks = { "*" = {}; }`.
  - `nixos/system-modules/core.nix`: `nixpkgs.config.allowUnfree = true` globally.
  - `nixos/system-modules/core.nix`: `programs.nix-ld.libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ];` is very broad.
- Maintainability/DRY
  - CI apps duplicate env setup (`NIX`, `APP_PREFIX`, `NIX_RUN`) and logging; fmt apps lack logging and share ad-hoc `--check` parsing.
  - `_lib` is passed into app modules but unused.
  - Hardcoded domain paths scattered across apps (e.g., `nixos`, `nvim/.config/nvim`, `.github/workflows`).
- Documentation mismatch
  - `nixos/AGENTS.md` says “Neovim, Fish, Starship out-of-store via mkOutOfStoreSymlink”; only Neovim does this and via a home path. No fish/starship repo configs exist to symlink.

## Plan

### 1) Fix lint config path (correctness)
- File: `nixos/apps/nixos-lint.nix`
- Change:
  - Detect `./statix.toml` at repo root; pass `--config ./statix.toml` when present.
  - Keep fallback without `--config` if file missing.
  - Continue to target the `nixos` directory for scanning.
- Rationale: Ensures statix uses the actual config. Current path never matches; config is ignored.
- Acceptance:
  - Running `nix run ./nixos#nixos-lint` uses the root `statix.toml` (verify by temporarily altering a rule and seeing a different outcome), and `nix run ./nixos#ci` passes this step.

### 2) Make Neovim config symlink repo-anchored, not user-anchored (portability)
- File: `nixos/home-modules/nvim.nix`
- Change:
  - Replace `source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/nvim/.config/nvim";` with a flake-root-relative path, e.g.:
    - `source = config.lib.file.mkOutOfStoreSymlink (toString ../../nvim/.config/nvim);`
  - This avoids relying on `${const.home_dir}/dotfiles` and works regardless of username or clone path.
- Notes:
  - Using `../../nvim/.config/nvim` is stable because the module file resides in `nixos/home-modules/` (two levels up to repo root, then into `nvim/.config/nvim`).
  - Alternative (future): if passing `self` through `specialArgs`, use `toString (self + "/nvim/.config/nvim")`.
- Acceptance:
  - Home Manager evaluation/build succeeds; Neovim config resolves when the repo is located anywhere.

### 3) Tighten SSH agent config (security) and remove redundancy
- File: `nixos/home-modules/ssh-agent.nix`
- Change:
  - Remove redundant `matchBlocks = { "*" = {}; };` since `enableDefaultConfig = false` and `extraConfig` already define a global Host.
  - Replace `AddKeysToAgent yes` with `AddKeysToAgent ask` to require confirmation, or remove this line entirely and rely on `programs.keychain` to manage agent loading.
  - Keep `programs.keychain` as is; it already integrates with shells.
- Acceptance:
  - SSH still works; keys are not auto-added without prompt. `nix run ./nixos#nixos-ci` unaffected.

### 4) Reduce unfree exposure (security/compliance)
- File: `nixos/system-modules/core.nix`
- Change:
  - Replace `nixpkgs.config.allowUnfree = true;` with a predicate:
    - `nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ /* list if needed */ ];`
  - Initial list can be empty if no unfree packages are required; add entries only if CI/build fails due to unfree packages.
- Process:
  - Run `nix run ./nixos#nixos-ci`. If failures cite unfree packages, add only those package names to the allowlist.
- Acceptance:
  - CI passes; only intentionally unfree packages are permitted.

### 5) Minimize nix-ld libraries (security/surface)
- File: `nixos/system-modules/core.nix`
- Change:
  - Replace `(pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ]` with a minimal, curated list based on actual needs. Start with just `[ pkgs.icu ]`.
  - Optionally gate broader sets via a boolean in `const` (e.g., `const.enable_broad_nix_ld`) defaulting to false.
- Process:
  - After narrowing, run `nix run ./nixos#nixos-ci`. If runtime tools break later, add specific libraries incrementally rather than using a kitchen-sink set.
- Acceptance:
  - CI passes and typical workflows run; no undue library bloat.

### 6) Remove unused `_lib` plumbing (cleanup)
- File: `nixos/apps/default.nix`
- Change:
  - Stop passing `_lib` to app module imports since it is unused everywhere.
- Acceptance:
  - `nix run ./nixos#ci` works and apps still resolve.

### 7) DRY the app scripts and centralize domain paths (maintainability)
- New file: `nixos/lib/app-helpers.nix`
  - Export:
    - `prelude = { name, appPrefixAttr ? true }: ''
      set -euo pipefail
      NIX="${pkgs.nix}/bin/nix"
      APP_PREFIX="./nixos#${appPrefixAttr then "apps.${pkgs.system}" else ""}"
      NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[${name}] $1" >&2; }
    ''` (exact implementation in Nix, returning a string)
    - `parseMode = ''mode=fix; case "${1-}" in --check) mode=check; shift;; esac''`
    - `paths = { nixosDir = "nixos"; nvimCfgDir = "nvim/.config/nvim"; workflowsDir = ".github/workflows"; statixConfig = "statix.toml"; }`
- Modify apps to consume helpers:
  - Files: `nixos/apps/ci.nix`, `nixos/apps/nixos-ci.nix`, `nixos/apps/nvim-ci.nix`, `nixos/apps/workflows-ci.nix`, `nixos/apps/nixos-fmt.nix`, `nixos/apps/nvim-fmt.nix`, `nixos/apps/workflows-lint.nix`, `nixos/apps/nixos-lint.nix`.
  - Replace local `NIX`, `APP_PREFIX`, `NIX_RUN`, `log` snippets with `app-helpers.prelude`.
  - Use `paths.*` constants instead of hardcoded strings (e.g., `find ${paths.nixosDir} ...`, `stylua ... ${paths.nvimCfgDir}`, `yamllint ${paths.workflowsDir}`).
  - Ensure `--check` handling for fmt apps is via `parseMode` and add logging at start and before each sub-step.
- Acceptance:
  - All apps behave identically but with consistent logging and no duplication. `nix run ./nixos#ci` passes.

### 8) Naming and dead code in apps (clarity)
- Decision: Keep domain-scoped app names (`nixos-fmt`, `nixos-lint`, `nixos-ci`, `nvim-fmt`, `nvim-ci`, `workflows-lint`, `workflows-ci`) as the canonical interfaces. The generic `fmt`/`lint` wrappers are optional conveniences; leave them as-is but ensure they are documented as wrappers.
- If desired later, rename or remove wrappers; not required for correctness.

### 9) Documentation alignment
- File: `nixos/AGENTS.md`
- Change:
  - Update the statement “Neovim, Fish, Starship out-of-store via mkOutOfStoreSymlink” to reflect current, supported state:
    - “Neovim config is linked out-of-store from this repo. Fish and Starship are managed via their Home Manager modules (no repo symlinks).”
  - Add note: Neovim link is repo-relative, not home-path-relative.
- Acceptance:
  - Doc matches code; no contradictions.

### 10) Optional: Make module imports explicit (predictability)
- Files: `nixos/configuration.nix`, `nixos/home.nix`
- Change:
  - Replace `import ./lib/import-modules.nix { inherit lib dir; };` with explicit lists in new `nixos/system-modules/default.nix` and `nixos/home-modules/default.nix` that return `[{ ...module1...; } { ...module2...; }]` via `imports = [ ... ]` or a literal list of `./file.nix`.
  - This prevents accidental imports by filename alone and gives deterministic ordering.
- Acceptance:
  - CI passes; adding a new file does nothing until explicitly referenced.

## Rollout order
1) 1, 2, 3 — correctness/portability/security; run `nix run ./nixos#ci`.
2) 4, 5 — security tightening; run CI and add allowlisted unfree packages only if needed.
3) 6, 7 — DRY refactor; run CI.
4) 9 — docs update; no CI impact.
5) 10 — optional explicit imports; run CI.

## Post-change verification
- Always: `nix run ./nixos#ci` (formats, lints, flake checks across NixOS, Neovim, Workflows).
- Sanity: Ensure Neovim launches with new symlink, SSH prompts/behavior acceptable, no unintended unfree package blocks.

## Out of scope (not necessary now)
- Moving dev toolchains from `environment.systemPackages` to Home Manager or devShells is a design preference; keep as-is for this fix.
- Multi-host flake structure; current single-host is acceptable.
