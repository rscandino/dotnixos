{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.boot.systemd-boot;
in {
  options.modules.boot.systemd-boot.enable = lib.mkEnableOption "Systemd-boot with efi access";

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    environment.systemPackages = with pkgs; [
      efibootmgr
    ];
  };
}
