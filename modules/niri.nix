{ config, lib, pkgs, ... }:
let cfg = config.moduleNiri; in
{
    options.moduleNiri.enable = lib.mkEnableOption "Niri compositor" // { default = false; };

    config = lib.mkIf cfg.enable {

        # Niri
        programs.niri.enable = true;

        # Packages
        environment.systemPackages = with pkgs; [
            fuzzel
            alacritty
        ];
    };
}
