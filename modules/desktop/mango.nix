# MangoWC compositor plus the session tools it needs.
# Requires mangowm.nixosModules.mango to be imported (done in flake.nix).
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.mango;
in {
  options.modules.desktop.mango.enable = lib.mkEnableOption "MangoWC compositor and session tools";

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;

    # required for xwayland
    services.xserver.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    # nautilus support
    services.gvfs.enable = true; # Trash, USB, network shares
    services.gnome.sushi.enable = true; # space-bar preview


    environment.systemPackages = with pkgs; [
      nautilus
      ffmpegthumbnailer
      gnome-text-editor
      polkit_gnome
      xdg-desktop-portal
      wlr-randr
      wl-clipboard
      grim
      slurp
      swaybg
      swayosd
      swayidle
      swaylock
      wleave
      fuzzel
      vimix-cursors
      adwaita-icon-theme
      foot
    ];
  };
}
