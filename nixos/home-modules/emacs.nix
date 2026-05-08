{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  home.sessionVariables = {
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c -a emacs";
  };

  xdg.configFile."emacs" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/emacs";
    recursive = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Better for Wayland/GNOME
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  home.packages = with pkgs; [
    # Runtime dependencies for Emacs
    ripgrep
    fd
    git
    gnumake
    cmake
    libtool

    # LSP Servers
    nixd
    pyright
    nodePackages.typescript-language-server
    lua-language-server
  ];
}
