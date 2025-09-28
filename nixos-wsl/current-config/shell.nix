{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  # Add necessary packages for the setup process
  buildInputs = with pkgs; [
    git # Used to clone the dotfiles repository
    coreutils # For the 'mv' command
    nixos-rebuild # The main tool for applying the new configuration
    openssh # For ssh-keygen to provision SSH keys
  ];
}
