**Hardcoded Paths**

- `nixos/lib/const.nix`: Hardcodes `user`, `home_dir`, `dotfiles_dir`, `locale`, `git` name/email.
- `nixos/home-modules/nvim.nix`: mkOutOfStoreSymlink to `"${const.dotfiles_dir}/nvim/.config/nvim"` (repo/user-specific).
- `nixos/apps/nixos-fmt.nix`: Searches only `nixos/` (literal repo subdir).
- `nixos/apps/nvim-fmt.nix`: Targets `nvim/.config/nvim` and `.stylua.toml` under that tree (literal paths).
- `nixos/apps/workflows-lint.nix`: Uses `.github/workflows` (literal, albeit assigned to a local var).

**DRY**

- `nixos/apps/{ci,nixos-ci,nvim-ci,workflows-ci}.nix`: Duplicate `NIX`, `APP_PREFIX`, `NIX_RUN` setup and logging helpers.
- `nixos/apps/{nixos-fmt,nvim-fmt}.nix`: Duplicate CLI mode parsing (`--check`) pattern.
- `nixos/home-modules/home-config.nix`, `nixos/system-modules/users.nix`: Redundant empty `packages = [ ];` pattern.

**Extract To Common Libs**

- `nixos/apps/*`: Shared CI shell glue (logging, `nix run` wrappers, repeated flags) not factored into a common helper/module.
- `nixos/apps/*`: Repeated domain paths (`nixos`, `nvim/.config/nvim`, `.github/workflows`) could be centralized (e.g., constants).
- `nixos/apps/default.nix`: Passing `_lib` to app modules that do not use it suggests missing shared helpers instead.

**Better Design Implementations**

- `nixos/lib/import-modules.nix`: Auto-imports every `.nix` file recursively and sorts by path; risks accidental imports and brittle ordering.
- `nixos/system-modules/core.nix`: `programs.nix-ld.libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ];` brings a very broad set; design leans heavy vs minimal.

**Group Scope Vars Early**

- `nixos/apps/{nixos-fmt,nvim-fmt}.nix`: Mixes arg parsing with command construction; some locals (`FIND_CMD`, `cfg`) defined mid-script rather than grouped up-front.

**Dead/Unused/Legacy**

- `nixos/apps/default.nix`: Supplies `_lib` into calls; unused by called files.
- `nixos/home-modules/ssh-agent.nix`: `matchBlocks = { "*" = {}; };` may be redundant with `extraConfig` `Host *` and `enableDefaultConfig = false`.
- `nixos/home-modules/home-config.nix`, `nixos/system-modules/users.nix`: Empty `packages` sets add no behavior.
- `nixos/apps/{fmt,lint}.nix`: Not referenced by `ci.nix` (may be manual-only; potentially unused within CI flow).

**Code Smells**

- `nixos/apps/nixos-lint.nix`: Looks for `nixos/statix.toml`; project’s `statix.toml` is at repo root (config likely ignored).
- `nixos/apps/*`: Hardcoded `"nix-command flakes"` flag strings repeated across apps.

**Naming Conventions**

- `nixos/apps/default.nix`: App names mix domain-less (`fmt`, `lint`) and domain-scoped (`nvim-fmt`, `workflows-lint`); ambiguous scope.

**Single Responsibility**

- `nixos/home-modules/nvim.nix`: Mixes editor enablement and session env vars; arguably fine but blends concerns.

**Modularity**

- `nixos/lib/import-modules.nix`: Implicit module discovery reduces explicit composition control, impacting modular clarity.

**Dependency Management**

- `nixos/system-modules/core.nix`: Global `allowUnfree = true` (broad).
- `nixos/system-modules/packages.nix`: Installs `nodePackages_latest.nodejs`, `python313`, `gcc` system-wide; potentially broader than necessary for runtime.
- `nixos/apps/workflows-lint.nix`: Pulls `actionlint` and `yamllint` as runtime inputs; fine but siloed.

**Error/Exception Handling**

- `nixos/apps/*`: Good `set -euo pipefail`; some scripts log failures explicitly (`nixos-ci`, `ci`, `workflows-ci`); others don’t (`nixos-fmt`, `nvim-fmt`).
- `nixos/apps/nvim-ci.nix`: Relies on `set -e` for failure propagation; minimal error context on format/check steps.

**Logging & Monitoring**

- `nixos/apps/{ci,nixos-ci,nvim-ci,workflows-ci}.nix`: Include basic timestamped logging; `nixos-fmt`/`nvim-fmt` lack any logging.
- No centralized logging level or structured output across apps.

**Conf. Vales (Env/Global)**

- `nixos/lib/const.nix`: Centralized constants, but includes mutable identity (user/email) and pathing assumptions for a single machine.
- `nixos/home-modules/nvim.nix`: Session vars set here; could be centralized if more shells/tools share them.

**Testing**

- No automated tests for modules or app scripts; relies on `flake check` and linters only.
- No integration tests for WSL module behavior or shell behaviors.

**Security Issues**

- `nixos/home-modules/ssh-agent.nix`: `AddKeysToAgent yes` globally; may auto-add keys broadly.
- `nixos/system-modules/core.nix`: Broad `nix-ld` library set expands attack surface.
- `nixos/system-modules/core.nix`: `allowUnfree = true` globally.

**Documentation Alignment**

- `nixos/AGENTS.md`: States “Neovim, Fish, Starship out-of-store via mkOutOfStoreSymlink”; only Neovim uses `mkOutOfStoreSymlink` in code (fish/starship do not).
- `nixos/apps/nixos-lint.nix`: Looks for `nixos/statix.toml`; actual `statix.toml` is at repo root (config likely not applied).

**Readability/Maintainability**

- `nixos/lib/import-modules.nix`: Implicit file-based import reduces explicitness and can surprise with new files.
- `nixos/apps/*`: Repeated shell snippets and flags increase maintenance overhead.
- `nixos/system-modules/packages.nix`: Category grouping is readable; still mixes dev/runtime tools in one module.

**Architecture & System Design**

- `nixos/flake.nix`: Single `nixosConfigurations.nixos`, single arch; not yet multi-host; apps hardcode per-system app resolution.
- `nixos/apps/default.nix`: Reasonable per-system app map; duplication of app wiring across domains.

**KISS**

- CI wrappers are straightforward but verbose due to duplication; simpler shared helper could reduce noise.

**SOLID**

- No findings.

**YAGNI**

- No findings.
