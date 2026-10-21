{ config, lib, pkgs, ... }:
let cfg = config.moduleDesktop; in
{
    options.moduleDesktop.enable = lib.mkEnableOption "Gnome desktop with audio" // { default = false; };

    config = lib.mkIf cfg.enable {

        # Gnome
        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = true;

        # Enable ZRAM
        zramSwap.enable = true;

        # Enable sound with pipewire.
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

        # Enable CUPS to print documents.
        services.printing.enable = true;

        # Packages
        environment.systemPackages = with pkgs; [
            firefox
            google-chrome
            alacritty
            ghostty
            telegram-desktop
        ];
    };
}
