{
  hasRole,
  lib,
  ...
}:

lib.mkIf (hasRole "desktop") {
  networking.firewall = {
    allowedTCPPorts = [
      53
      80
      443
    ];
    allowedUDPPorts = [
      53
      67
    ];
  };
}
