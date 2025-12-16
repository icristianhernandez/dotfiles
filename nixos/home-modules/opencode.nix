{
  config,
  const,
  lib,
  pkgs,
  hasRole,
  ...
}:
{
  config = lib.mkIf (hasRole "development") {
    xdg.configFile."opencode/opencode.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/opencode.json";
    };

    home.packages = with pkgs; [ opencode ];
  };
}
