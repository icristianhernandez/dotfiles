{ const, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        inherit (const.git) name email;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
