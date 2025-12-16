{ pkgs, const, ... }:
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

      # Testing these
      pull.rebase = true;
      core.editor = "${pkgs.neovim}/bin/nvim";
      fetch.prune = true;
      diff.algorithm = "histogram";
    };
  };
}
