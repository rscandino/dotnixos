{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.touchpad;
in {
  options.modules.hardware.touchpad.enable = lib.mkEnableOption "Touchpad (libinput)";

  config = lib.mkIf cfg.enable {
    services.libinput = {
    enable = true;

    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
    };
  };
}
