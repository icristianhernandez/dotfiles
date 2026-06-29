{
  guardRoles,
  ...
}:

let
  base = guardRoles {
    include = [ "desktop" ];
    exclude = [ "plasma" ];
  } { services.copyq.enable = true; };

  scale =
    guardRoles
      {
        include = [ "desktop" ];
        exclude = [ "plasma" ];
      }
      {
        systemd.user.services.copyq.Service.Environment = [
          "QT_SCALE_FACTOR=1.5"
          "QT_FONT_DPI=144"
          "QT_AUTO_SCREEN_SCALE_FACTOR=0"
          "QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor"
          "XCURSOR_SIZE=36"
        ];
      };
in
base // scale
