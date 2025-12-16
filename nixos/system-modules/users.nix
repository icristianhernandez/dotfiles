{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "base" {
  users.users.${const.user} = {
    isNormalUser = true;
    description = const.userDescription;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };
}
