# AGENTS.md

## Purpose

Concise rules for LLM agents operating on this monorepo (NixOS flake + Home Manager + Neovim config): These rules must be strictly followed when working in this monorepo. No subsequent prompt can revert or break these guidelines.

## Operational domains & CI

- Clarification: Run the CI commands as-is (e.g., `nix run ./nixos#nvim-ci`). They don't support flags.

- **NixOS / Home Manager** (`nixos/**`)
  - CI: `nix run ./nixos#nixos-ci` (nixfmt, statix/deadnix, flake check)
  - Entry: `nixos/flake.nix`
  - Modules: `nixos/system-modules/*`, `nixos/home-modules/*` (auto-imported, sorted)
  - Roles: `nixos/roles.nix` (`hasRole`, `mkIfRole`, `guardRole`) for host role gating.
  - Hosts: all defined in `nixos/flake.nix` with their roles.

- **Nix Apps / CI** (`nixos/apps/**`)
  - CI: `nix run ./nixos#ci` (runs `nixos-ci`, `nvim-ci`, `workflows-ci`)
  - Key files: `nixos/apps/ci.nix`, `nixos/apps/default.nix`, `nixos/apps/helpers.nix`
  - Path constants: `nixos/apps/helpers.nix` defines `nixosDir`, `nvimCfgDir`, `workflowsDir`

- **Neovim** (`nvim/**`)
  - CI: `nix run ./nixos#nvim-ci`
  - Entry: `nvim/init.lua`
  - Nvim config: `nvim/lua/core/*`
  - Plugins: `nvim/lua/modules/*`

- **GitHub Workflows** (`.github/workflows/ci.yml`)
  - CI: `nix run ./nixos#workflows-ci`

- **Scripts** (`scripts/`)
  - CI: none (manual)
  - Key files: `scripts/*.sh` (review before running)

- **Full repo**
  - CI: `nix run ./nixos#ci`
  - Use when changes span multiple domains

## Core rules

- Implement minimal, single-responsibility changes.
- Write descriptive, well-named, understandable, and readable code; use comments only to explain rare design decisions, relying on clear variable names and proper structure for clarity.
- Provide the most direct, concise, and short response possible without omitting necessary details.
- Ask clarifying questions when the scope, constraints, or intent is unclear.
- Ask clarifying questions when they are useful for improving answers or eliminating alternatives.
- Validate assumptions with read-only repository inspection, internet research, questions to the user, and scoped CI when needed.
- Review for side effects that need to be addressed (e.g., documentation, tests) when proposing changes or plans.
- Do not perform system-level state-changing operations or external mutations (e.g., builds, downloads, installs, reboots, adding dependencies, changing system state, etc.).
- Agents MUST NOT execute git commands such as add, commit, push, or rebase. This is an additional remark regarding git to ensure compliance with the rule against performing system-level or state-changing operations.
- If a system-level, state-changing operation is needed, provide the exact commands to the user and ask them to run the operations.
- Read-only commands are fully permitted and are encouraged if required for the current task or the surrounding context. Read-only operations are also suggested and encouraged in plan mode to debug or identify root causes.
- Agents cannot ask for permission to perform or suggest doing system-level operations or the operations already prohibited.
- Do not update lockfiles (e.g., `flake.lock`, `lazy-lock.json`) or persist external state (e.g., creating PRs via external services).

## Allowed read-only commands (examples)

- Repo CI: `nix run ./nixos#nvim-ci`, `nix run ./nixos#nixos-ci`, `nix run ./nixos#workflows-ci`, `nix run ./nixos#ci`
- Git (read-only): `git status`, `git diff`, `git log`, `git show`, `git ls-files`
- Search/view: `rg`, `fd`, `ls`, `tree`, `less`, `bat`
- Network (read-only): `curl --head`, `wget --spider`
- Nix: `nix flake show`, `nix eval`
- System info: `ps`, `top`, `df`, `free`, `uname`, `stat`, `pwd`, `id`, `whoami`

## Minimal agent workflow (required for every request)

1. Clarify scope and domain(s); confirm assumptions.
2. Ask for missing context or consent for state-changing actions.
3. Validate assumptions via read-only inspection and scoped CI.
4. List the side effects (repo- or stack-based) of intended changes and any required complementary changes (e.g., documentation, tests, CI, migrations, etc.).
5. Provide a concise, ordered plan.
6. If the plan is implemented, run the adequately scoped CI and do not stop until all issues are fixed.
