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
  # TODO: the following line is being set as a compat, I think can be removed
  xdg.userDirs.setSessionVariables = true;
}
