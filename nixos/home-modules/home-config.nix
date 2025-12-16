{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "base" {
  home = {
    username = const.user;
    homeDirectory = const.homeDir;
    stateVersion = const.homeState;
    packages = with pkgs; [ ];
  };
}
