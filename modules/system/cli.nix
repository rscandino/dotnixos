{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.cli;
in {
  options.modules.system.cli.enable = lib.mkEnableOption "Everyday CLI and diagnostic tools";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      usbutils
      lshw
      tree
      fzf
      zoxide
      eza
      bat
      htop
      unzip
      zip
    ];
  };
}
