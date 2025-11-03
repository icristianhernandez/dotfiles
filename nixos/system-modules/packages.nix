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
        nodejs_24
        gcc
        (python313.withPackages (ps: [ ps.pip ]))
      ];
      dev_env = with pkgs; [
        neovim
        opencode
        nvimpager
        nixd
        tree-sitter
      ];
    in
    pkgs.lib.concatLists [
      os_base
      cli_utils
      languages
      dev_env
    ];
}
