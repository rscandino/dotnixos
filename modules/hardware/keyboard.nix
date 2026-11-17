{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.keyboard;
in {
  options.modules.hardware.keyboard = {
    enable = lib.mkEnableOption "Keyboard layout settings";

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      example = "it";
      description = "XKB layout (comma-separated for several).";
    };

  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      inherit (cfg) layout;
    };

    # TTY / early boot uses the same layout
    console.useXkbConfig = true;

    # Wayland compositors (wlroots-based) read these
    environment.sessionVariables = {
      XKB_DEFAULT_LAYOUT = cfg.layout;
    };
  };
}
