# configuration.nix
{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # ------ Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ------ Enable ZRAM
  zramSwap.enable = true;

  # ------ Networking
  networking.hostName = "zbook";
  networking.networkmanager.enable = true;

  # ------ User
  users.users.riccardo = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "passpass";
  };

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
