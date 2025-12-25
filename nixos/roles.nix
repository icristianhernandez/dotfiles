{ lib }:
let
  allowedRoles = [
    "base"
    "wsl"
    "interactive"
    "dev"
    "desktop"
    "thinkpadE14"
    "dms"
    "gnome"
  ];

  validateRoles =
    roles:
    let
      unknown = lib.filter (r: !(lib.elem r allowedRoles)) roles;
    in
    if unknown == [ ] then
      true
    else
      builtins.throw ("Unknown roles: " + lib.concatStringsSep ", " unknown);

  mkHelpers =
    roles:
    let
      hasRole = role: lib.elem role roles;
      mkIfRole = role: lib.mkIf (hasRole role);
      guardRole = role: block: if hasRole role then block else { };
    in
    {
      inherit hasRole mkIfRole guardRole;
    };

  module = {
    options.roles = lib.mkOption {
      type = lib.types.listOf (lib.types.enum allowedRoles);
      default = [ ];
      description = "List of roles applied to this host.";
    };
  };
in
{
  inherit
    allowedRoles
    module
    mkHelpers
    validateRoles
    ;
}
