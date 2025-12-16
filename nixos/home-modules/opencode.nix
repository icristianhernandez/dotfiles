{
  config,
  const,
  pkgs,
  ...
}:
{
  xdg.configFile."opencode/opencode.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/opencode.json";
  };

  home.packages = with pkgs; [ opencode ];
}
