{ config, pkgs, ... }:
{
  users.users.cristianwslnixos = {
    isNormalUser = true;
    description = "cristian hernandez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
