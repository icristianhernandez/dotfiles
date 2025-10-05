{ pkgs, ... }:
{
  environment.systemPackages =
    let
      os_base = with pkgs; [
        ntfs3g
        openssh
      ];
      cli_utils = with pkgs; [
        unrar
        wget
        curl
        ripgrep
        fd
        gnutar
        unzip
      ];
      languages = with pkgs; [
        nodePackages_latest.nodejs
        gcc
        python313
        python313Packages.pip
      ];
      dev_env = with pkgs; [
        neovim
        opencode
        nvimpager
      ];
    in
    pkgs.lib.concatLists [
      os_base
      cli_utils
      languages
      dev_env
    ];
}
