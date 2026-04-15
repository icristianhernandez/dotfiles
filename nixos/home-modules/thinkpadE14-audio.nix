{
  guardRole,
  ...
}:

# - setup:
# thinkpadE14 gen 2, intel
# - physical setup:
# Used the built-in speaker/microphone at one arm's length (~70cm). The laptop is
# 15cm above the desktop, inclined by approximately 30 degrees by a laptop base.
# - Speaker used (the builtin one)
# Intel Tiger Lake-LP Smart Sound Technology, Subsystem Lenovo Device 5087.
# Realtek ALC257

let
  inputPreset = builtins.fromJSON (builtins.readFile ./easyeffects-thinkpad-e14-input.json);
  outputPreset = builtins.fromJSON (builtins.readFile ./easyeffects-thinkpad-e14-output.json);

in
guardRole "thinkpadE14" {
  services.easyeffects = {
    enable = true;

    extraPresets = {
      "Thinkpad E14 Input Enchancement" = inputPreset;
      "Thinkpad E14 Output Enchancement" = outputPreset;
    };
  };
}
