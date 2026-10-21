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

  # ------ Features
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # ------ Updates
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  # ------ Nix storage management
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  # ------ Proprietary garbage
  nixpkgs.config.allowUnfree = true;

  # ------ Locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # ------ Graphics drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    prime = {
      offload.enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
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

  # ------ Install Fonts
  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # ------ Enable modules
  moduleDev.enable = true;
  moduleDesktop.enable = true;
  moduleGaming.enable = true;

  moduleNiri.enable = true;

  moduleDotfiles = {
    enable = true;
    directory = "/home/riccardo/Projects/dotfiles";
  };


  # ------ State
  # Set to the NixOS release you first installed; do not bump it later.
  system.stateVersion = "26.05";
}
