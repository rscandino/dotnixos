{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.laptop;
in {
  options.modules.laptop.enable = lib.mkEnableOption "Laptop power management, touchpad and backlight";

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
    services.upower.enable = true;
    services.actkbd.enable = true;

    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        middleEmulation = true;
      };
    };

    environment.systemPackages = [pkgs.brightnessctl];
  };
}
