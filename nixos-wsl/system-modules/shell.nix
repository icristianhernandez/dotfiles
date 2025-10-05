{ pkgs, ... }:
{
  programs = {
    fish.enable = true;

    starship = {
      enable = true;
      presets = [ "bracketed-segments" ];
    };

    bash = {
      enable = true;

      # bash remain as login shell but exec fish when runned interactively
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
