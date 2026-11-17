{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.intel;
in {
  options.modules.hardware.intel.enable = lib.mkEnableOption "Intel hardware cpu/graphics";

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ];
      };
      cpu.intel.updateMicrocode = true;
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
