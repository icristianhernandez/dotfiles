let
  user = "cristianwslnixos";
in
{
  inherit user;
  home_dir = "/home/${user}";
  dotfiles_dir = "${home_dir}/dotfiles";
  system_state = "25.05";
  home_state = "25.05";
  locale = "en_US.UTF-8";
  user_description = "cristian hernandez";
  git = {
    name = "cristian";
    email = "cristianhernandez9007@gmail.com";
  };
}
