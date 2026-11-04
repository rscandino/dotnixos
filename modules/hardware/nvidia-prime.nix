# Hybrid Intel + NVIDIA graphics with PRIME offload
{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nvidiaPrime;
in {
  options.modules.nvidiaPrime = {
    enable = lib.mkEnableOption "NVIDIA PRIME offload";

    intelBusId = lib.mkOption {
      type = lib.types.str;
      example = "PCI:0@0:2:0";
      description = "Bus ID of the Intel GPU (see lspci).";
    };

    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      example = "PCI:1@0:0:0";
      description = "Bus ID of the NVIDIA GPU (see lspci).";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = ["modesetting" "nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        inherit (cfg) intelBusId nvidiaBusId;
      };
    };
  };
}
