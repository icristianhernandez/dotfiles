{
  config,
  pkgs,
  lib,
  const,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.sessionVariables = {
    MANPAGER = "nvim +Man! -";
    PAGER = "nvim -";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/nvim/.config/nvim";
    recursive = true;
  };
}
