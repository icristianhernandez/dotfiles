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

      # bash remain as login shell but exec fish when run interactively
      interactiveShellInit = ''
        # Only exec fish if we're in an interactive shell and parent is not fish
        if [[ $- == *i* ]] && [[ -z ''${BASH_EXECUTION_STRING} ]]; then
          parent_comm=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm 2>/dev/null || echo "unknown")
          if [[ "$parent_comm" != "fish" ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        fi
      '';
    };
  };
}
