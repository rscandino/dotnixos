{ config,lib,...}: let
cfg = config.modules.desktop.displayManager;
in {
  options.modules.desktop.displayManager = {

    enable = lib.mkEnableOption "Login display manager";

    name = lib.mkOption {
      type = lib.types.enum ["ly" "gdm" "sddm"];
      default = "ly";
      description = ''
        Available display managers are ly,gdm,sddm.
      '';
      };
    };

    config = lib.mkIf cfg.enable {

      services.displayManager.${cfg.name}.enable = true;

      };

  }
