{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modNiri;
in {
  options.modNiri.enable = lib.mkEnableOption "Niri compositor" // {default = false;};

  config = lib.mkIf cfg.enable {
    # Niri
    programs.niri.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      swaybg
      swaylock
      swayidle
      vimix-cursors
      adwaita-icon-theme
      fuzzel
      alacritty
    ];
  };
}
