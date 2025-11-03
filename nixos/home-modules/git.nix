{ const, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        inherit (const.git) name email;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
