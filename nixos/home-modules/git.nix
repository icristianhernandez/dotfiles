{ const, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = const.git.name;
        email = const.git.email;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
