{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.powerManagement;
  tlp = cfg.tlp;
in {
  options.modules.hardware.powerManagement = {
    enable = lib.mkEnableOption "Laptop power management";

    backend = lib.mkOption {
      type = lib.types.enum ["ppd" "tlp"];
      default = "ppd";
      description = ''
        ppd: power-profiles-daemon. Manual profile switching
        (powerprofilesctl), simple, nothing to tune.
        tlp: automatic AC/battery switching plus device tuning and
        optional charge thresholds.
      '';
    };

    thermald = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run thermald (Intel thermal management).";
    };

    tlp = {
      battery = lib.mkOption {
        type = lib.types.str;
        default = "BAT0";
        description = "Battery name used for charge thresholds (see /sys/class/power_supply).";
      };

      chargeThresholds = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            start = lib.mkOption {
              type = lib.types.ints.between 0 100;
              default = 75;
            };
            stop = lib.mkOption {
              type = lib.types.ints.between 0 100;
              default = 80;
            };
          };
        });
        default = null;
        description = ''
          Battery charge thresholds. Only set if
          ls /sys/class/power_supply/BAT0/ shows charge_control_end_threshold.
        '';
      };

      extraSettings = lib.mkOption {
        type = lib.types.attrsOf (lib.types.oneOf [lib.types.str lib.types.int lib.types.bool]);
        default = {};
        description = "Extra TLP settings, merged over the defaults below.";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.backend == "ppd" && tlp.chargeThresholds != null);
          message = "modules.hardware.powerManagement.tlp.chargeThresholds requires backend = \"tlp\".";
        }
      ];

      powerManagement.enable = true;

      services.upower.enable = true;
      services.thermald.enable = cfg.thermald;

      environment.systemPackages = with pkgs; [acpi];
    }

    (lib.mkIf (cfg.backend == "ppd") {
      services.power-profiles-daemon.enable = true;
      services.tlp.enable = false;
    })

    (lib.mkIf (cfg.backend == "tlp") {
      services.power-profiles-daemon.enable = false;

      services.tlp = {
        enable = true;
        settings =
          {
            CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

            # Check /sys/firmware/acpi/platform_profile_choices for valid values
            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "balanced";

            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;
            CPU_HWP_DYN_BOOST_ON_AC = 1;
            CPU_HWP_DYN_BOOST_ON_BAT = 0;
          }
          // lib.optionalAttrs (tlp.chargeThresholds != null) {
            "START_CHARGE_THRESH_${tlp.battery}" = tlp.chargeThresholds.start;
            "STOP_CHARGE_THRESH_${tlp.battery}" = tlp.chargeThresholds.stop;
          }
          // tlp.extraSettings;
      };
    })
  ]);
}
