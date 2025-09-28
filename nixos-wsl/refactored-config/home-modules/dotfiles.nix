{
  config,
  lib,
  ...
}:
{
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim/";
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    VISUAL = lib.mkDefault "nvim";
  };
}
