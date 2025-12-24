{
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.vicinae = {
    enable = true;
    useLayerShell = true;
    systemd = {
      enable = true;
      autoStart = true;
      target = "graphical-session.target";
    };
  };
}
