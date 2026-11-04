# Everyday graphical applications and printing.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps;
in {
  options.modules.apps.enable = lib.mkEnableOption "everyday desktop applications";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      firefox
      google-chrome
      ghostty
      telegram-desktop
      gimp
      inkscape
      loupe
      gnome-text-editor
    ];
  };
}
