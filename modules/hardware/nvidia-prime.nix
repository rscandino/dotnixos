{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.nvidiaPrime;
in {
  options.modules.hardware.nvidiaPrime = {
    enable = lib.mkEnableOption "NVIDIA PRIME hybrid graphics";

    mode = lib.mkOption {
      type = lib.types.enum ["offload" "sync" "reverseSync"];
      default = "offload";
      description = ''
        offload: iGPU drives the display, NVIDIA renders only when asked (best battery).
        sync: NVIDIA renders everything (best performance, worst battery).
        reverseSync: NVIDIA drives the display, iGPU assists (experimental).
      '';
    };

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

    open = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use the open kernel modules (Turing and newer only).";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      defaultText = lib.literalExpression "config.boot.kernelPackages.nvidiaPackages.stable";
      description = "NVIDIA driver package (e.g. nvidiaPackages.beta or .production).";
    };

    finegrainedPower = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Power the dGPU fully off when idle. Only valid with mode = offload.";
    };

    vaapi = lib.mkEnableOption "NVIDIA VA-API video decode (nvidia-vaapi-driver)";

    igpuPciAddress = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "0000:00:02.0";
      description = ''
        PCI address of the iGPU. Creates /dev/dri/igpu and points the
        wlroots compositor at it (WLR_DRM_DEVICES), so it does not pick
        the NVIDIA GPU and keep it awake.
        Check with "udevadm info -a /dev/dri/card1 | grep KERNELS" (card0 etc)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.mode != "offload" || cfg.igpuPciAddress != null;
        message = "modules.hardware.nvidiaPrime: set igpuPciAddress in offload mode.";
      }
      {
        assertion = config.modules.hardware.intel.enable;
        message = "modules.hardware.nvidiaPrime expects modules.hardware.intel to be enabled.";
      }
    ];

    # Also what makes Wayland sessions load the NVIDIA kernel driver
    services.xserver.videoDrivers = ["modesetting" "nvidia"];

    hardware.nvidia = {
      inherit (cfg) open package;
      modesetting.enable = true;
      nvidiaSettings = true;

      # Needed for suspend/resume (relevant to lid suspend and clamshell)
      powerManagement.enable = true;
      powerManagement.finegrained = cfg.finegrainedPower;

      prime = {
        inherit (cfg) intelBusId nvidiaBusId;
        offload = lib.mkIf (cfg.mode == "offload") {
          enable = true;
          enableOffloadCmd = true;
        };
        sync.enable = cfg.mode == "sync";
        reverseSync.enable = cfg.mode == "reverseSync";
      };
    };

    services.udev.extraRules = lib.mkIf (cfg.igpuPciAddress != null) ''
      SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="${cfg.igpuPciAddress}", SYMLINK+="dri/igpu"
    '';

    environment.sessionVariables = lib.mkIf (cfg.igpuPciAddress != null) {
      WLR_DRM_DEVICES = "/dev/dri/igpu";
    };

    environment.systemPackages = lib.mkIf cfg.vaapi [pkgs.nvidia-vaapi-driver];
  };
}
