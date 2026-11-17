{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.boot.plymouth;
in {
  options.modules.boot.plymouth = {
    enable = lib.mkEnableOption "Plymouth and quiet boot setup";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "loader_2";
      description = ''
        Plymouth theme to select. For list of themes check https://github.com/adi1090x/plymouth-themes
        Theme names are lowercase, replace "spaces" with "_"
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = cfg.theme;
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [cfg.theme];
          })
        ];
      };

      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
        "splash"
        "udev.log_priority=3"
      ];

      # rollback selection timeout
      loader.timeout = 3;
    };
  };
}
