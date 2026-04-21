# Just trying that.
{ guardRole, ... }:

guardRole "dev" {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
