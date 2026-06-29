{ guardRole, ... }:

guardRole "interactive" {
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
  };
}
