{ const, ... }:
{
  programs.git = {
    enable = true;
    userName = const.git.name;
    userEmail = const.git.email;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
