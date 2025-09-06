# This file defines the dotfiles that will be linked into the home directory
# by Home Manager. Separating this data makes it easier to manage.
{
  # Directories that should be linked recursively.
  recursive = {
    ".config/nvim" = ../../nvim/.config/nvim;
    ".config/fish" = ../../fish/.config/fish;
  };

  # Single files that should be linked.
  single = {
    ".config/starship.toml" = ../../starship/.config/starship.toml;
  };
}
