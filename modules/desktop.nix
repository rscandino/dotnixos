{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modDesktop;
in {
  options.modDesktop.enable = lib.mkEnableOption "Desktop setup no dekstop envinroment" // {default = false;};

  config = lib.mkIf cfg.enable {
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

    # ------ Install Fonts
    fonts.packages = with pkgs; [
      maple-mono.NF
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    # Packages
    environment.systemPackages = with pkgs; [
      firefox
      google-chrome
      alacritty
      ghostty
      kitty
      telegram-desktop
      gimp
      inkscape
    ];
  };
}
