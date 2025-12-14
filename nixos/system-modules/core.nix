{ pkgs, const, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld = {
    enable = true;
    # NOTE: steam-run.args.multiPkgs includes a large set of libraries (~2GB).
    # This is necessary for running non-NixOS binaries that expect standard FHS paths.
    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ];
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-generations +3";
    };
    optimise.automatic = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = const.system_state;

  time.timeZone = "America/Caracas";
}
