{ config, const, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    PAGER = "nvimpager";
    GIT_PAGER = "nvimpager";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/nvim";
    recursive = true;
  };
}
