# MangoWC compositor plus the session tools it needs.
# Requires mangowm.nixosModules.mango to be imported (done in flake.nix).
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.mango;
in {
  options.modules.mango.enable = lib.mkEnableOption "MangoWC compositor and session tools";

  config = lib.mkIf cfg.enable {

    programs.mango.enable = true;

    # required for xwayland
    services.xserver.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    environment.systemPackages = with pkgs; [
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
      fuzzel
      vimix-cursors
      adwaita-icon-theme
      foot
    ];
  };
}
