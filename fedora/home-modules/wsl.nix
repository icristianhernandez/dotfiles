{ const, guardRole, ... }:

guardRole "wsl" {
  home.file.".wslconf" = {
    text = ''
      [boot]
      systemd=true

      [user]
      default=${const.user}
    '';
  };

  # Use Windows host drivers for graphics acceleration (Vulkan, OpenGL)
  home.sessionVariables = {
    MESA_LOADER_DRIVER_OVERRIDE = "d3d12";
  };
}
