{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.fonts;
in {
  options.modules.fonts.enable = lib.mkEnableOption "System fonts";

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
