{ const, lib, hasRole, ... }:
{
  config = lib.mkIf (hasRole "wsl") {
    wsl = {
      enable = true;
      defaultUser = const.user;
      # interop.register = true;
      useWindowsDriver = true;
    };
  };
}
