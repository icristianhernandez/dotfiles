{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "base" {
  nixpkgs.config.allowUnfree = true;

  # hack to execute third party binaries found here:
  # https://wiki.nixos.org/wiki/FAQ#I've_downloaded_a_binary,_but_I_can't_run_it,_what_can_I_do?
  programs.nix-ld = {
    enable = true;
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = const.systemState;

  time.timeZone = const.timezone;
}
