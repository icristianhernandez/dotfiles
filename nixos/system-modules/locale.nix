{
  const,
  lib,
  guardRole,
  ...
}:
let
  loc = const.locale;
  localeCategories = [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ];
in
guardRole "base" {
  i18n.defaultLocale = loc;
  i18n.extraLocaleSettings = lib.genAttrs localeCategories (_: loc);
}
