{ const, guardRole, ... }:

guardRole "dev" {
  virtualisation.docker.enable = true;

  users.users.${const.user}.extraGroups = [ "docker" ];
}
