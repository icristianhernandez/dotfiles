{ pkgs }:
attrs:
let
  program = attrs.program or (throw "mkApp: 'program' attribute is required");
  argv = attrs.argv or [ ];
  meta = attrs.meta or { };

  # Validate program is a string or path
  programStr =
    if builtins.isString program then
      program
    else if builtins.isPath program then
      toString program
    else
      throw "mkApp: 'program' must be a string or path, got ${builtins.typeOf program}";

  # Validate argv is a list
  _ = assert builtins.isList argv || throw "mkApp: 'argv' must be a list"; null;

  wrapper =
    if (argv == [ ]) then
      null
    else
      pkgs.writeShellApplication {
        name = "mkapp-wrapper";
        runtimeInputs = [ ];
        text = ''
          exec ${programStr} ${pkgs.lib.escapeShellArgs argv} "$@"
        '';
      };
in
{
  type = "app";
  program = if wrapper == null then programStr else "${wrapper}/bin/mkapp-wrapper";
  inherit meta;
}
