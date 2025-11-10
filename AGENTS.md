# AGENTS.md

Monorepo: NixOS (WSL-focused) flake + Home Manager + standalone Neovim config.
Agents must follow these rules for safe, effective changes.

## Quick Commands (local)

- Full CI (all domains): `nix run ./nixos#ci`
- NixOS domain CI: `nix run ./nixos#nixos-ci`
- Neovim domain CI: `nix run ./nixos#nvim-ci`
- Workflows domain CI: `nix run ./nixos#workflows-ci`

Use scoped CI if you changed only one domain; use full CI if edits span multiple domains.

## Domains

### NixOS / Home

- Path: `nixos/`
- System modules configured in: `system-modules`
- Home manager modules configured in: `home-modules`
- User data stored in `lib/const.nix`. Use that to store and reuse any user specific data.
- Avoid running builds or suggest doing that.

### Neovim

- Path: `nvim/.config/nvim/`
- Modules (group of plugins): `lua/modules/`
- Core config (options, autocmds, keymaps, plugin manager): `lua/core/`
- Stylua config: `.stylua.toml`
- Style: snake_case locals; module filenames kebab-case; return table or function; avoid globals (`vim.g` only for explicit settings). Keep modules single-responsibility.

### GitHub Workflows

- Path: `.github/workflows/`

## Do / Don't (Safety & Constraints)

- Don’t: Run VCS operations (e.g., `git add`, `git commit`, `git push`), ask the user to stage or commit, or ever suggest that I perform these actions unless explicitly instructed by the user.
- Critical: OS-modifying actions require explicit confirmation. For any command that modifies repository or system state (including VCS commands, file writes, package installs, `rm`, or system configuration), agents must:
  - Default to output-only: provide the commit message, patch, or the exact shell commands to run; do not execute commands.
  - If the user requests execution, require one explicit single-line confirmation in the form `Confirm: <exact command>` before running anything.
  - Require an additional explicit confirmation for destructive commands.
  - Treat ambiguous phrases like "apply the edit", "make live", or "deploy" as requiring clarification before taking action.
- Don’t: Edit or update package lockings files like `flake.lock`, `lazy-lock.json`, etc.
- Don’t: Perform system changes, heavy builds (e.g. `nix build --toplevel`), or re-builds (e.g. `nixos-rebuild`).
- Don’t: Add secrets or fetch environment secrets (`builtins.getEnv`).
- Don’t: Introduce global mutable state.
- Do: Run the appropriate CI command (fix → lint → check) before concluding.
- Do: Keep changes minimal and single-responsibility.
- Do: Preserve existing module patterns (e.g., return table/function in Lua).
- Do: Keep lists one-item-per-line for diff clarity.

## CI & Checks

- Run the appropriate scoped CI (nvim-ci, nixos-ci) if changes are isolated to one domain.
- Run the full umbrella CI (ci) if edits span multiple domains.
- If CI appears to miss changes, ask the user to stage their files and re-run.
- Always summarize which sub-step failed and why.

## Editing & Structure

- Keep changes minimal and scoped; one feature/responsibility per change.
- When adding modules: follow existing module export patterns and naming conventions.

## Security & Safety

- System-level operations are completely prohibited: builds, download packages,apps or librarys, shutdowns, system-level configs or variable, VSC/git operations, etc.
  - The only exception for the above are read-only operations that doesn't mess with user system and are required to some tasks, like git status, logs, etc.

## Communication

- Before any side-effect command: brief preamble of intent.
- After file edits: summarize what changed and why, referencing paths.
- On failure: surface exit code, failing step, and next action (see Failure Handling).

## Side Effects & Documentation

The new instructions need to be followed by each user requirement.

- Assess all side effects or edge cases: docs, performance, compatibility. And consider these in the plans.
- Update README only when high-level usage changes; otherwise keep documentation minimal.

### Example Workflows

## Example Workflow (Neovim change)

1. Plan minimal, scoped change.
2. Edit Lua module (return table/function).
3. Run `nix run ./nixos#nvim-ci`.
4. Fix reported issues (format/lint).
5. Summarize changes + CI status.

## Example Workflow (Questions)

1. Clarify scope and desired outcome with the user.
2. Check if the answer can be derived from the current conversation or repo; list any missing facts or files needed.
3. If external research is beneficial, identify specific sources to consult (official docs, RFCs, library API pages, changelogs) and ask the user for permission to fetch/summarize them.
4. Perform targeted research (only after permission), synthesize findings, and produce a concise, referenced answer with options or recommendations.
5. Offer next actions: code edits, tests, further questions, or a plan for follow-up work.
6. Always include a short (1–2 sentence) summary at the end of the response and suggest 1–3 clear next actions the user can take.

Always clarify needed context, avoid assumptions, and cite the exact source and location for all web research data based answers.

## Example Workflow (General change)

1. Plan minimal, scoped change.
2. Edit relevant files.
3. Run appropriate CI (scoped or full).
4. Fix issues.
5. Summarize changes and CI outcomes.

## Glossary

- Domain: one of nixos, nvim, workflows.
- CI umbrella: runs all domain CI apps in sequence.
- Fix mode: formatting or auto-fix operations.
- Check mode: verification without applying changes.
