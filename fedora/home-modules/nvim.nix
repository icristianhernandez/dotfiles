{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    PAGER = "nvim";
    GIT_PAGER = "nvim";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/nvim";
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Runtime dependencies
      ripgrep
      fd
      tree-sitter
      lsof

      # Formatters
      nixfmt

      # LSPs
      nixd
    ];
  };
}
