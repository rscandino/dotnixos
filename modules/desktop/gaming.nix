{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.gaming;
in {
  options.modules.desktop.gaming.enable = lib.mkEnableOption "Steam, gamemode and gaming tools";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      discord-ptb
      mangohud
    ];
  };
}
