{ pkgs }:
attrs:
let
  program = attrs.program or null;
  argv = attrs.argv or [ ];
  meta = attrs.meta or { };
  wrapperName = "mkapp-wrapper-${builtins.substring 0 8 (builtins.hashString "sha256" program)}";
  wrapper =
    if (argv == [ ]) then
      null
    else
      pkgs.writeShellApplication {
        name = wrapperName;
        runtimeInputs = [ ];
        text = ''
          exec ${program} ${pkgs.lib.escapeShellArgs argv} "$@"
        '';
      };
in
if program == null then
  throw "mkApp: 'program' is required"
else
  {
    type = "app";
    program = if wrapper == null then program else "${wrapper}/bin/${wrapperName}";
    inherit meta;
  }
