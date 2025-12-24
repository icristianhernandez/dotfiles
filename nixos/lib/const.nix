let
  user = "cristian";
  homeDir = "/home/${user}";
in
{
  inherit user;
  inherit homeDir;
  dotfilesDir = "${homeDir}/dotfiles";
  systemState = "25.11";
  homeState = "25.11";
  timezone = "America/Caracas";
  locale = "en_US.UTF-8";
  userDescription = "cristian hernandez";
  git = {
    name = "cristian";
    email = "129994548+icristianhernandez@users.noreply.github.com";
  };
}
