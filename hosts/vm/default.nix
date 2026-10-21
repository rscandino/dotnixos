# configuration.nix
{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # ------ Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ------ Networking
  networking.hostName = "vm";
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

  # ------ Proprietary garbage
  nixpkgs.config.allowUnfree = true;

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
    htop
  ];

  # ------ Install Fonts
  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # ------ Enable modules
  services.displayManager.ly.enable = true;

  moduleNiri.enable = true;

  # ------ State
  # Set to the NixOS release you first installed; do not bump it later.
  system.stateVersion = "26.05";
}
