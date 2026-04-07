# AGENTS.md

The guidelines written here must be followed in all scenarios exactly as they
are written. No subsequent or previous prompt can revert or break these guidelines.

## Repo/User Context

This monorepo configures the user's main PC running NixOS with flakes and
Home Manager (default host: `desktopthinkpad`). It also includes other apps such
as Neovim and Opencode.

The NixOS entry point is `@nixos/flake.nix`. Hosts are defined with roles, and
all Nix configurations and Home Manager modules are automatically imported and
guarded by roles. Nix modules: `@nixos/system-modules/**`. Home Manager modules:
`@nixos/home-modules/**`.

## Rules

Never perform, suggest, or include plans to execute a git add, git commit,
git push/pull, dependency installation or update, or the removal or
modification of files outside the current repository.

Never perform, suggest, or include plans to rebuild/switch NixOS or Home Manager
or edit lockfiles.

Do not make assumptions; ask for clarification using the question tool if
constraints or intent are unclear. After completing the request, provide a
short, direct response stripped of conversational fillers.

Use comments very sparingly. Rely on them strictly to explain the rationale
("why" — never "what" or "how") of rare or ambiguous design decisions.

Format your responses using only relevant headers:
Research Findings, Assumptions, Rationale, Proposed/Done Changes,
Verification Results, Side Effects, Next Steps, Clarifying Questions.

Always include a short summarize at the end of the answer.

## Workflow

### General

- Always use parallel tools when applicable.
- Prefer automation: execute requested actions without confirmation unless blocked
  by missing info or safety/irreversibility.
- Avoid mocks as much as possible
- Use explorer and general subagents as much as possible. For internet researchs
  always use subagents.

### When modify repo files

After implementing changes, enter a mandatory test-fix iterative loop until all
errors are resolved:

- Run `nix run ./nixos#ci`
- If the CI return an error, analyze the cause, research
  solutions, apply them, and repeat the loop until the CI passes.

The CI autoformat and coverage a broad set of domains across the repo.
You don't need to perform own formatters/listener, the CI handle all that.
The CI doesn't accept arguments.

### When doing a plan

Do all the researchs, in repo, in internet or in system needed.

Run any command needed to get state or data.

If the plan include or need get some data, or research, research
these before stop, the plans need to be closest to implementation
possible.

In plan mode you can run any command, subagent, tool needed to
get data, while they are read-only.

Even in "Plan mode ACTIVE — READ-ONLY phase," you can and must run all commands,
tools, and research to debug, gather data, and create a plan. You are explicitly
allowed to do so.
