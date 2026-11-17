# Everyday graphical applications and printing.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps;
in {
  options.modules.desktop.apps.enable = lib.mkEnableOption "Everyday desktop applications";

  config = lib.mkIf cfg.enable {

    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      firefox
      google-chrome
      ghostty
      loupe
      telegram-desktop
      gimp
      inkscape
      freecad
      bambu-studio
    ];
  };
}
