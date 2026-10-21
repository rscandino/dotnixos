# Runs GNU Stow at login so ~/.dotfiles stays symlinked into $HOME
# Nix only installs stow and re-runs it
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.moduleDotfiles;
in {
  options.moduleDotfiles = {
    enable = lib.mkEnableOption "Stowing dotfiles at login" // {default = false;};

    directory = lib.mkOption {
      type = lib.types.str;
      default = "%h/.dotfiles"; # %h = the user's home (systemd specifier)
      description = "Where the dotfiles repo is checked out.";
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.stow];

    systemd.user.services.stow-dotfiles = {
      description = "Symlink dotfiles with GNU Stow";
      wantedBy = ["default.target"];
      unitConfig.ConditionPathExists = cfg.directory; # skip if not present at path
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = cfg.directory;
        ExecStart = "${pkgs.stow}/bin/stow --restow --no-folding --target=%h .";
      };
    };
  };
}
