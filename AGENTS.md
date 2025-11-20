# AGENTS — short

## Purpose

Concise rules for LLM agents operating on this monorepo (NixOS flake + Home Manager + Neovim config): These rules must be strictly followed when working in this monorepo.

## Operational domains & CI

- NixOS / Home: `nixos/` — CI: `nix run ./nixos#nixos-ci` — key files: `system-modules/*`, `home-modules/*`, `lib/const.nix`
- Neovim: `nvim/` — CI: `nix run ./nixos#nvim-ci` — key files: `lua/core/`, `lua/modules/`, `init.lua`
- GitHub Workflows: `.github/workflows/` — CI: `nix run ./nixos#workflows-ci` — key files: `.github/workflows/*`
- Full repo: `/` — CI: `nix run ./nixos#ci` — use only when change spans domains

Clarification: Run the above CI commands as-is (e.g., `nix run ./nixos#nvim-ci`); you generally do not need to pass extra arguments or flags.

## Core rules

- Do minimal, single-responsibility changes.
- Ask clarifying questions when scope, constraints, or intent are unclear.
- Validate assumptions with read-only repo inspection and scoped CI when needed.
- Document impacts (docs, tests, migrations, CI scope, security) and request approval for actions with elevated risk.
- Don't perform system-level or state-changing operations (builds, downloads, installs, reboots, system config) without explicit authorization.
- Don't update lockfiles (e.g., `flake.lock`, `lazy-lock.json`) or persist external state (e.g., create PRs via external services) without explicit authorization.
- VCS policy: Agents MUST NOT execute VCS write operations (e.g., `git add`, `git commit`, `git push`, `git rebase`, `gh pr create`). Agents MUST NOT propose, draft, or suggest diffs, commit messages, PR titles or bodies, or commands that perform VCS writes. Agents may describe required code changes or show code snippets/unified diffs only when explicitly requested, and must never include commit/PR metadata or runnable VCS commands.

## Critical constraints (non-negotiable)

- **NO VCS writes:** Agents MUST NEVER run `git add`, `git commit`, `git push`, `git rebase`, `gh pr create`; Agents MUST NOT propose, draft, or suggest diffs, commit messages, PR titles or bodies, or commands that perform VCS writes, even when asked. Agents may describe required code changes or show code snippets/unified diffs only when explicitly requested, and must never include commit/PR metadata or runnable VCS commands.
- **NO VCS MENTIONS:** Agents MUST NOT mention, suggest, prompt, or ask for VCS write actions (e.g., "git add/commit/push", "gh pr create", "rebase", or "Apply and commit?"). Agents may prepare diffs/patches and explain changes, but must not reference or recommend commit steps; the user must explicitly request any VCS commands.
- **NO external mutation:** Do not create PRs or change external services; read-only network requests (curl/wget) are acceptable for verification.
- **NO lockfile edits:** Never manually edit `flake.lock` or `lazy-lock.json`.
- **NO system-level state changes without explicit consent:** no reboot, shutdown, or package installs outside of Nix declarations.

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
4. List impacts and required complementary changes (docs, tests, CI, migrations).
5. Provide a concise, ordered plan and wait for explicit consent for state-changing operations.
6. If applied, run the adequately scoped CI and fix any errors before finishing.
