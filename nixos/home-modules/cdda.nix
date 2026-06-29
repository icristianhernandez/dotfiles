{
  pkgs,
  guardRole,
  ...
}:
let
  cddaLib = pkgs.unstable.cataclysmDDA;
  cc-sounds = cddaLib.buildSoundPack {
    modName = "CC-Sounds";
    version = "2025-11-15";
    src = pkgs.fetchzip {
      url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/2025-11-15/CC-Sounds.zip";
      hash = "sha256-esMFyijsCWldF2iBCoBxy6CVe+Ld03z/on4MiIs5V+Y=";
    };
    postPatch = ''
      find . -name soundpack.txt -exec sed -i 's/\r$//' {} +
    '';
  };
  undeadpeople = cddaLib.pkgs.tileset.UndeadPeople;
in
guardRole "gaming" {
  home.file = {
    ".cataclysm-dda/gfx/UndeadPeople".source = "${undeadpeople}/share/cataclysm-dda/gfx/UndeadPeople";
    ".cataclysm-dda/sound/CC-Sounds".source = "${cc-sounds}/share/cataclysm-dda/sound/CC-Sounds";
  };
}
