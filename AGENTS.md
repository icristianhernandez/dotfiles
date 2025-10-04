# Dotfiles for a NixOS-on-WSL setup using Nix flakes and Home

Manager, plus curated Neovim, shell, and dev tooling configs

## Technologies

- Nix/NixOS/WSL: flake, NixOS on WSL, Home Manager modules.
- Neovim: Lua config with Lazy.nvim and LazyVim.
- Shell: fish config; Starship prompt.
- Tools: yazi, SSH agent.
- CI: GitHub Actions, statix, deadnix, nixfmt, Stylua.

## Paths

- NixOS + Home: `nixos-wsl/system-modules/*`,
  `nixos-wsl/home-modules/*`, `configuration.nix`, `home.nix`,
  `nixos-wsl/lib/*`, `nixos-wsl/apps/`.
- Neovim: `nvim/.config/nvim/*` (plugins in `lua/plugins/*.lua`,
  settings in `lua/config/*.lua`).
- Shell: `fish/.config/fish/*`.
- CI: `.github/workflows/ci.yml`.

## Commands

- NixOS format (fix): `nix run ./nixos-wsl#apps.x86_64-linux.nixos-fmt`
- NixOS CI: `nix run ./nixos-wsl#apps.x86_64-linux.nixos-ci`
- Neovim format (fix): `nix run ./nixos-wsl#apps.x86_64-linux.nvim-fmt`
- Neovim CI: `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`
- Workflows CI: `nix run ./nixos-wsl#apps.x86_64-linux.workflows-ci`
- Orchestrator (all): `nix run ./nixos-wsl#apps.x86_64-linux.ci`

## Agent Conventions

- Nearest `AGENTS.md` wins; root is fallback.
- Security: no secrets in repo; avoid `builtins.getEnv`.
- Make declarative changes; avoid side effects.
- Never run or suggest VCS (git) commands.
- Run checks after edits and fix failures.
- Do not update `nixos-wsl/flake.lock`.

## Subconfig Guidelines

Read and follow the subconfig agents guidelines when performing any actions
related to these guidelines.

- See `nixos-wsl/AGENTS.md` for Nix subconfig.
- See `nvim/.config/nvim/AGENTS.md` for Neovim subconfig.
- Read and follow the required AGENTS.md before editing.
