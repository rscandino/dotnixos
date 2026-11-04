{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.dotfiles;
in {
  options.modules.dotfiles = {
    enable = lib.mkEnableOption "Stowing dotfiles at login";

    directory = lib.mkOption {
      type = lib.types.str;
      default = "%h/.dotfiles"; # %h = the user's home (systemd specifier)
      description = "Where the dotfiles repo is checked out";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.stow];

    systemd.user.services.stow-dotfiles = {
      description = "Symlink dotfiles with GNU Stow";
      wantedBy = ["default.target"];
      unitConfig.ConditionPathExists = cfg.directory;
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = cfg.directory;
        ExecStart = "${pkgs.stow}/bin/stow --restow --no-folding --target=%h .";
      };
    };
  };
}
