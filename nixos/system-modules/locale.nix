{
  const,
  lib,
  guardRole,
  ...
}:
let
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
  i18n.defaultLocale = const.systemLanguage;
  i18n.extraLocaleSettings = lib.genAttrs localeCategories (_: const.parametersLanguage);
}
