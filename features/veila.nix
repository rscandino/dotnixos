{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modVeila;
in {
  options.modVeila.enable = lib.mkEnableOption "Enable veila lockscreen" // {default = false;};

  config = lib.mkIf cfg.enable {
    # install and enable veila
    environment.systemPackages = with pkgs; [veila];
    security.pam.services.veila = {};

    # Google Fonts collection contains Geom, Google Sans Flex, and Nunito
    fonts.packages = with pkgs; [google-fonts];

  };
}
