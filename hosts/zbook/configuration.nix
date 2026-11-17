{config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;

  # ----- Modules -----
  modules = {

    boot = {
      systemd-boot.enable = true;
      plymouth.enable = true;
    };

    hardware = {
      intel.enable = true;
      nvidiaPrime = {
        enable = true;
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
        igpuPciAddress = "0000:00:02.0";
      };
      powerManagement = {
        enable = true;
        backend = "tlp";
        tlp.chargeThresholds = {
          start = 75;
          stop = 80;
        };
      };
      touchpad.enable = true;
      keyboard.enable = true;
    };

    system = {
      user.name = "riccardo";
      nix.enable = true;
      locale.enable = true;
      networkManager = {
        enable = true;
        hostName = "zbook";
      };
      dev.enable = true;
      dotfiles = {
        enable = true;
        directory = "/home/${config.modules.system.user.name}/Projects/dotfiles";
      };
      cli.enable = true;
    };

    desktop = {
      audio.enable = true;
      fonts.enable = true;
      displayManager.enable = true;
      apps.enable = true;
      gaming.enable = true;
      mango.enable = true;
      clamshell.enable = true;
    };

  };

  # Set to the NixOS release you first installed; do not bump it later.
  system.stateVersion = "26.05";
}
