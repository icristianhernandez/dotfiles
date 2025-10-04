{ lib }:
attrs:
let
  program = attrs.program or null;
  meta = if builtins.hasAttr "meta" attrs then attrs.meta else { };
  _ = if program == null then throw "mkApp: 'program' is required" else null;
in
{
  type = "app";
  inherit program meta;
}
