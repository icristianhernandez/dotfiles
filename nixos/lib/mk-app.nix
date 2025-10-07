_: attrs:
let
  program = attrs.program or null;
  meta = if builtins.hasAttr "meta" attrs then attrs.meta else { };
in
if program == null then
  throw "mkApp: 'program' is required"
else
  {
    type = "app";
    inherit program meta;
  }
