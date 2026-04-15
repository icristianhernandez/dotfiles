{
  pkgs,
  guardRole,
  ...
}:

guardRole "thinkpadE14" {
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  services.udev.extraRules = ''
    # Set mild brightness boost when the camera is initialized
    ACTION=="add", SUBSYSTEM=="video4linux", ATTR{name}=="Integrated Camera: Integrated C", \
      RUN+="${pkgs.v4l-utils}/bin/v4l2-ctl -d $devnode --set-ctrl=brightness=135"
  '';

  services.pipewire.wireplumber.extraConfig = {
    "91-v4l2-mjpg" = {
      "monitor.v4l2.rules" = [
        {
          matches = [
            { "node.name" = "~v4l2_input.*"; }
          ];
          actions = {
            "update-props" = {
              "node.param.Props" = {
                "video.format" = "MJPG";
                "video.size" = {
                  "width" = 1280;
                  "height" = 720;
                };
              };
            };
          };
        }
      ];
    };
  };
}
