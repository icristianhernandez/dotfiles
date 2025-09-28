{
  config,
  pkgs,
  const,
  ...
}:
{
  users.users.${const.user} = {
    isNormalUser = true;
    description = const.user_description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };
}
