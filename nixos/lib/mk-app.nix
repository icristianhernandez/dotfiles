{ pkgs }:
attrs:
let
  program = attrs.program or null;
  argv = if builtins.hasAttr "argv" attrs then attrs.argv else [ ];
  meta = if builtins.hasAttr "meta" attrs then attrs.meta else { };
  wrapper =
    if (argv == [ ]) then
      null
    else
      pkgs.writeShellApplication {
        name = "mkapp-wrapper";
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
    program = if wrapper == null then program else "${wrapper}/bin/mkapp-wrapper";
    inherit meta;
  }
