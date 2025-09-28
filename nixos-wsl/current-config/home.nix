{ config, pkgs, ... }:

{
  home.username = "cristianwslnixos";
  home.homeDirectory = "/home/cristianwslnixos";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ]; 
    extraFlags = [ "--quiet" ];
    enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/cristianwslnixos/dotfiles/nvim/.config/nvim/";
    recursive = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "cristian";
    userEmail = "cristianhernandez9007@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.yazi.enable = true;
}
