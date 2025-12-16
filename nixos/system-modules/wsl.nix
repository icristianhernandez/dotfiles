{ const, ... }:
{
  wsl = {
    enable = true;
    defaultUser = const.user;
    # interop.register = true;
    useWindowsDriver = true;
  };
}
