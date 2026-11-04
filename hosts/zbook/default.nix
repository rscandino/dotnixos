{config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "zbook";
  networking.networkmanager.enable = true;

  myUser.name = "riccardo";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  services.displayManager.ly.enable = true;

  modules = {
    laptop.enable = true;
    nvidiaPrime = {
      enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };

    mango.enable = true;
    audio.enable = true;
    fonts.enable = true;
    apps.enable = true;
    nautilus.enable = true;

    cli.enable = true;
    dev.enable = true;
    clamshell.enable = true;
    dotfiles = {
      enable = true;
      directory = "/home/${config.myUser.name}/Projects/dotfiles";
    };
  };

  # Set to the NixOS release you first installed; do not bump it later.
  system.stateVersion = "26.05";
}
