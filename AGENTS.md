# AGENTS.md

Monorepo: NixOS (WSL-focused) flake + Home Manager + standalone Neovim config.
Agents must follow these rules for safe, effective changes.

## Quick Commands (local)

- Full CI (all domains): `nix run ./nixos#ci`
- NixOS CI: `nix run ./nixos#nixos-ci`
- Neovim CI: `nix run ./nixos#nvim-ci`
- Workflows CI: `nix run ./nixos#workflows-ci`

Use scoped CI for domain-limited changes.

## Domains

### NixOS / Home

- Path: `nixos/`
- System modules: `system-modules`
- Home modules: `home-modules`
- User constants: `lib/const.nix`

### Neovim

- Path: `nvim/`
- Plugin modules: `lua/modules/`
- Core config: `lua/core/`

### GitHub Workflows

- Path: `.github/workflows/`

## Guiding Principles (Do / Don't)

- Do: Keep changes minimal and single-responsibility. If CI reports errors outside your scope, inform the user but do not fix them.
- Do: Run appropriate scoped CI when validating domain-scoped changes or when explicitly requested by the user.
- Do: Conduct research (local and internet) and other read-only operations to gather context.
- Do: Assess and communicate the impact of your changes.
  - Note effects on docs, performance, security, and compatibility.
  - Document user-facing changes (e.g., configuration, migrations).
  - Identify necessary test updates and the required CI scope.
  - Obtain explicit consent before making changes that affect security or require elevated privileges.

- Don't: Perform system-level operations or modify state without explicit authorization. This includes:
  - Builds, downloads, or installations.
  - Shutdowns or reboots.
  - System-level configuration changes.
  - VCS/Git operations that write changes (e.g., `git add`, `git commit`).
  - Agents MUST NEVER run VCS/Git write operations. This is an absolute prohibition: agents are COMPLETELY, TOTALLY, AND UNCONDITIONALLY PROHIBITED from performing any VCS/Git write operation under ANY circumstances, including when explicitly requested by a user, or when the agent deems it "necessary" or convenient (this includes but is not limited to `git add`, `git commit`, `git push`, `git rebase`, `git reset`, `gh pr create`). Agents MUST NOT present diffs, propose commit messages, suggest VCS write commands, offer PR content, or initiate conversations about git commits, pull requests, or similar topics unless the user explicitly requests such artifacts or discussion. When explicitly requested by the user, agents may present diffs, propose commit messages, and provide step-by-step instructions for the user to run VCS commands. Agents MAY run domain-scoped CI commands or other non-mutating, read-only inspection/debugging commands when necessary to validate or debug requested changes, or when necessary to accomplish the user's requested task. Agents must never execute any VCS write operations themselves.
  - Exception: Agents MAY and are STRONGLY ADVISED to run domain-scoped CI commands (e.g., `nix run ./nixos#nvim-ci`) and non-mutating, read-only inspection/debugging commands without explicit authorization when validating or debugging domain-scoped changes. The list below is referential (not exhaustive); other read-only commands may be used depending on context if they respect the constraints described.

```json
{
  "repo_ci": [
    "nix run ./nixos#nvim-ci",
    "nix run ./nixos#nixos-ci",
    "nix run ./nixos#workflows-ci",
    "nix run ./nixos#ci"
  ],
  "git (read-only; only when necessary for the task)": [
    "git status",
    "git log",
    "git diff",
    "git show",
    "git ls-files",
    "git rev-parse",
    "git remote -v"
  ],
  "search": ["rg", "fd", "find", "ls", "tree"],
  "viewers": ["less", "bat", "head", "tail", "jq"],
  "network": ["curl(GET/HEAD)", "wget --spider"],
  "nix": ["nix flake show", "nix eval"],
  "system": [
    "ps",
    "top",
    "df",
    "free",
    "uptime",
    "uname",
    "stat",
    "pwd",
    "id",
    "whoami"
  ],
  "constraints": "read-only flags only; domain-scoped CI permitted"
}
```

- Don't: Update dependency lockfiles (e.g., `flake.lock`, `lazy-lock.json`).
- Don't: Interact with external services in ways that persist state (e.g., creating PRs).

Always clarify needed context, avoid assumptions, and cite the exact source and location for all web research data based answers.

## Minimal Agent Workflow Requirement

Agents must perform the following steps for every user request:

- Do: Clarify scope (task + domain(s)) and state assumptions before taking action.
- Do: Identify missing context and request any critical information needed to proceed.
- Do: Validate assumptions with read-only inspection or permitted research.
- Do: Assess and list side effects and required complementary changes (documentation, migrations, tests, CI scope).
- Do: Produce a concise ordered plan of changes and await confirmation or explicit consent for state-changing operations.

- Don't: Proceed without scoping, context validation, impact assessment, and a plan.
- Don't: Perform system-level or state-changing operations (builds, installs, reboots, config mutations, VCS writes) without explicit user authorization except the permitted commands.
- Don't: Omit disclosure of required migrations, configuration changes, or CI/test impacts.
