{ const, guardRole, ... }:
guardRole "wsl" {
  wsl = {
    enable = true;
    defaultUser = const.user;
    # interop.register = true;
    useWindowsDriver = true;
  };
}
