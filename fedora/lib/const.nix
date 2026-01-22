let
  user = "cristian";
  homeDir = "/home/${user}";
in
{
  inherit user;
  inherit homeDir;
  dotfilesDir = "${homeDir}/dotfiles";
  systemState = "23.11";
  homeState = "23.11";
  timezone = "America/Caracas";
  systemLanguage = "en_US.UTF-8";
  parametersLanguage = "es_ES.UTF-8";
  userDescription = "cristian hernandez";
  git = {
    name = "cristian";
    email = "129994548+icristianhernandez@users.noreply.github.com";
  };
}
