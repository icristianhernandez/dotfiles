{ config, ... }:

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
    source = config.lib.file.mkOutOfStoreSymlink (toString ../../nvim/.config/nvim);
    recursive = true;
  };
}
