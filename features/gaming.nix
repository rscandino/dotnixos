{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modGaming;
in {
  options.modGaming.enable = lib.mkEnableOption "Steam and gamemode" // {default = false;};

  config = lib.mkIf cfg.enable {
    # PRIME Graphics drivers hybrid-mode offload
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["modesetting" "nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };

    # STEAM
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    # GAMEMODE
    programs.gamemode.enable = true;

    # DISCORD and MANGOHUD
    environment.systemPackages = with pkgs; [
      discord-ptb
      mangohud
    ];
  };
}
