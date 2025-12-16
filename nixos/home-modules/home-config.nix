{
  pkgs,
  const,
  guardRole,
  hostName,
  ...
}:

guardRole "base" {
  home = {
    username = const.user;
    homeDirectory = const.homeDir;
    stateVersion = const.homeState;
    packages = with pkgs; [ ];

    sessionVariables = {
      NIXOS_HOST = hostName;
    };
  };
}
