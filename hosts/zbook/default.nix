# configuration.nix
{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # ------ Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ------ Networking
  networking.hostName = "zbook";
  networking.networkmanager.enable = true;

  # ------ User
  users.users.riccardo = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "passpass";
  };

  # ------ Locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # ------ System packages
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


# Gnome
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;


  # ------ Enable modules
  modNix.enable = true;
  modDev.enable = true;
  modDesktop.enable = true;
  modGaming.enable = true;

  modNiri.enable = true;

  modDotfiles = {
    enable = true;
    directory = "/home/riccardo/Projects/dotfiles";
  };


  # ------ State
  # Set to the NixOS release you first installed; do not bump it later.
  system.stateVersion = "26.05";
}
