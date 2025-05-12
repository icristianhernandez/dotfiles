# My Personal Dotfiles

Welcome to my personal dotfiles repository. These are the exact configurations I use on my Arch Linux WSL setup with Fish shell, Neovim, and Starship prompt. This is tailored for my own workflow—feel free to browse, but it’s primarily for my own convenience.

## Quick Start

1. Clone the repo or update your local copy:

   ```bash
   git clone git@github.com:icristianhernandez/dotfiles.git ~/dotfiles || \
   (cd ~/dotfiles && git pull)
   ```

2. Run the setup script:

   ```bash
   sh ~/dotfiles/dotfiles-bootstrap.sh
   ```

### One-liner via curl

If you want to pipe it directly from GitHub:

```bash
curl -fsSL https://github.com/icristianhernandez/dotfiles/raw/main/dotfiles-bootstrap.sh | bash
```

## After Setup

- Launch a new Fish session to enjoy the Starship prompt.
- Open `nvim` or `neovide` to load LazyVim with my custom plugins and keymaps.
- Explore the keybindings under `<leader>` in Neovim (space bar by default).

## Customization & Maintenance

I’m always tweaking these configs:

- Update Neovim plugins from `nvim/` by running `:Lazy update` inside Neovim.
- Modify shell functions or aliases in `fish/config.fish`.
- Tune prompt segments in `starship/starship.toml`.
- Track tasks and ideas in `notes/global.md`.

---

*Last updated: May 12, 2025*
