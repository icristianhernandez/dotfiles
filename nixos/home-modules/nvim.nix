{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  home.packages = with pkgs; [
    bat
    delta
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    MANWIDTH = "999";
    PAGER = "bat";
    GIT_PAGER = "delta";
  };

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/nvim";
  };

  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    package = pkgs.neovim-unwrapped;
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
