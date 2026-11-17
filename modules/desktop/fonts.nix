{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts.enable = lib.mkEnableOption "System fonts";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      maple-mono.NF
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.monaspace
      nerd-fonts.symbols-only
    ];
  };
}
