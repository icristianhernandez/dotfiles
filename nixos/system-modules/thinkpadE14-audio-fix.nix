{
  guardRole,
  ...
}:

guardRole "thinkpadE14" {
  # Eliminates governor ramp-up latency that causes buffer underruns under load
  # powerManagement.cpuFreqGovernor = "performance";

  services.pipewire = {
    ## Fixes pop/crack when apps like Chrome interact with the audio subsystem
    # wireplumber.extraConfig = {
    #   "10-disable-suspension" = {
    #     "monitor.alsa.rules" = [
    #       {
    #         matches = [
    #           { "node.name" = "~alsa_output.*"; }
    #           { "node.name" = "~alsa_input.*"; }
    #         ];
    #         actions.update-props."session.suspend-timeout-seconds" = 0;
    #       }
    #     ];
    #   };
    # };

    # Doubles DSP time budget (42.6ms vs 21.3ms) for convolution + multiband chain
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 4096;
      };
    };
  };
}
