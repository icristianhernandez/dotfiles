{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # OS related things
    ntfs3g
    # Utilities
    unrar wget curl ripgrep fd gnutar unzip keychain
    # Languages
    nodePackages_latest.nodejs gcc python313 python313Packages.pip
    # Dev Env
    neovim neovide opencode
  ];
}
