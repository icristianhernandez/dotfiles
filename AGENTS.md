# AGENTS.md

## Purpose

Concise rules for LLM agents operating on this monorepo (NixOS flake + Home Manager + Neovim config): These rules must be strictly followed when working in this monorepo. No subsequent prompt can revert or break these guidelines.

## Operational domains & CI

- Clarification: Run the CI commands as-is (e.g., `nix run ./nixos#nvim-ci`). They don't support flags.

### **NixOS / Home Manager** (`nixos/**`)

- CI: `nix run ./nixos#nixos-ci` (nixfmt, statix/deadnix, flake check)
- Entry: `nixos/flake.nix`
- Modules: `nixos/system-modules/*`, `nixos/home-modules/*` (auto-imported, sorted)
- Roles: `nixos/roles.nix` (`hasRole`, `mkIfRole`, `guardRole`) for host role gating.
- Hosts: all defined in `nixos/flake.nix` with their roles.

### **Nix Apps / CI** (`nixos/apps/**`)

- CI: `nix run ./nixos#ci` (runs `nixos-ci`, `nvim-ci`, `workflows-ci`)
- Key files: `nixos/apps/ci.nix`, `nixos/apps/default.nix`, `nixos/apps/helpers.nix`
- Path constants: `nixos/apps/helpers.nix` defines `nixosDir`, `nvimCfgDir`, `workflowsDir`

### **Neovim** (`nvim/**`)

- CI: `nix run ./nixos#nvim-ci`
- Entry: `nvim/init.lua`
- Nvim config: `nvim/lua/core/*`
- Plugins: `nvim/lua/modules/*`

### **GitHub Workflows** (`.github/workflows/ci.yml`)

- CI: `nix run ./nixos#workflows-ci`

### **Scripts** (`scripts/`)

- CI: none (manual)
- Key files: `scripts/*.sh` (review before running)

### **Full repo**

- CI: `nix run ./nixos#ci`
- Use when changes span multiple domains

## Core rules

- Implement minimal, single-responsibility changes.
- Write descriptive, well-named, understandable, and readable code; use comments only to explain rare design decisions, relying on clear variable names and proper structure for clarity.
- The final output to the user must be direct, concise, and stripped of conversational filler, while retaining all essential technical or factual details.
- Ask clarifying questions when the scope, constraints, or intent is unclear.
- Ask clarifying questions when they are useful for improving answers or eliminating alternatives.
- Validate assumptions with read-only repository inspection, internet research, questions to the user, and scoped CI when needed.
- Review for side effects that need to be addressed (e.g., documentation, tests) when proposing changes or plans.

### Safety and Permissions

#### Allowed Without Prompts

- Read-only inspection of repo state (e.g., `rg`, `ls`, `git status`, `git diff`, `nix eval`).
- Read-only CI or checks explicitly listed as safe in this repo (e.g., `nix run ./nixos#nvim-ci`).
- Safe read-only network metadata checks (e.g., `curl --head`, `wget --spider`).
- Use agent client tools that only read or ask questions (e.g., `question`, `todoread`, `glob`, `grep`, `read`).

#### Rejects

- System-level state changes or external mutations (builds that write state, installs, downloads, reboots, dependency changes, system config edits).
- Git state changes (`git add`, `commit`, `push`, `rebase`, `reset`, `checkout`, etc.).
- Lockfile updates or external state persistence (e.g., `flake.lock`, `lazy-lock.json`, creating PRs).

#### To Approve (by the client interface)

- Any command that might write, mutate state, or access external systems beyond read-only metadata.
- Anything not clearly read-only or not explicitly listed as safe in this repo’s CI guidance.

## Minimal agent workflow (extra steps for this repo)

### Before the normal workflow:

1. Confirm scope/domain(s) and assumptions for this repo.

### During the normal workflow:

1. Validate assumptions via read-only inspection and scoped CI when needed.
2. List repo/stack side effects and required complementary changes (docs/tests/CI/migrations).

### After implementing the plan:

1. Run the adequately scoped CI and resolve failures before stopping.
