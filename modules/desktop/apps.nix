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

    # nautilus support
    services.gvfs.enable = true; # Trash, USB, network shares
    services.gnome.sushi.enable = true; # space-bar preview

    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      nautilus
      ffmpegthumbnailer
      adwaita-icon-theme
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
