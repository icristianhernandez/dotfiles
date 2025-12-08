{ config, const, ... }:
{
  xdg.configFile."opencode/opencode.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/opencode/opencode.json";
  };
}
