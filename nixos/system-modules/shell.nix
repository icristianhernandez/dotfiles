{ pkgs, guardRole, ... }:
guardRole "interactive" {
  programs = {
    fish.enable = true;

    starship = {
      enable = true;
      presets = [ "bracketed-segments" ];
    };

    bash = {
      enable = true;

      # Bash remains as login shell but execs fish when run interactively
      # https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell:~:text=Tips%20and%20tricks-,Setting%20fish%20as%20default%20shell,-Using%20fish%20as
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };

  environment.pathsToLink = [ "/share/fish" ];
}
