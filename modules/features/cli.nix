{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.cli;
in {
  options.modules.cli.enable = lib.mkEnableOption "Everyday CLI and diagnostic tools";

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
    ];
  };
}
