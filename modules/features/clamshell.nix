# Clamshell mode for wayland WM that dont built-in it (mango, hyperland, ...)
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.clamshell;

  clamshell = pkgs.writeShellApplication {
    name = "clamshell";
    runtimeInputs = [pkgs.wlr-randr pkgs.libinput pkgs.coreutils pkgs.gnugrep];
    text = ''
      INTERNAL="${cfg.internalOutput}"

      has_external() {
        wlr-randr | grep -E '^[A-Za-z]' | grep -qv "^$INTERNAL"
      }

      echo "Service clamshell started"

      libinput debug-events 2>/dev/null | while read -r line; do
        case "$line" in
          *SWITCH_TOGGLE*lid*state\ 1*)
            echo "Lid closed"
            if has_external; then
              echo "External monitor found, internal off"
              wlr-randr --output "$INTERNAL" --off
            fi ;;
          *SWITCH_TOGGLE*lid*state\ 0*)
            echo "Lid open, internal on"
            wlr-randr --output "$INTERNAL" --on ;;
        esac
      done
    '';
  };
in {
  options.modules.clamshell = {
    enable = lib.mkEnableOption "Clamshell mode (internal display off when lid closed with external monitor)";

    internalOutput = lib.mkOption {
      type = lib.types.str;
      default = "eDP-1";
      description = "Name of the internal display output (see wlr-randr).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };

    # libinput debug-events needs access to the input devices
    users.users.${config.myUser.name}.extraGroups = ["input"];

    environment.systemPackages = [clamshell pkgs.wlr-randr];

    systemd.user.services.clamshell = {
      description = "Disable internal display when lid is closed";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${clamshell}/bin/clamshell";
        Restart = "always";
        RestartSec = 2;
      };
    };
  };
}
