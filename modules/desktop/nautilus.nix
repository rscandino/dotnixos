{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nautilus;
in {
  options.modules.nautilus.enable = lib.mkEnableOption "Nautilus file manager";

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true; # Trash, USB, network shares
    services.gnome.sushi.enable = true; # space-bar preview

    environment.systemPackages = with pkgs; [
      nautilus
      ffmpegthumbnailer
      adwaita-icon-theme
    ];
  };
}
