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
    packages = with pkgs; [ ];

    sessionVariables = {
      NIXOS_HOST = hostName;
    };
  };
}
