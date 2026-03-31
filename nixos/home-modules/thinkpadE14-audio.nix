{
  guardRole,
  ...
}:

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
