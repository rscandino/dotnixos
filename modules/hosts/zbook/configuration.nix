# Unique host params of /etc/nixos/configuration.nix here
{ ... }: {

  flake.nixosModules.zbookConfiguration = { pkgs, config, ... }: {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zbook";
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };


  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;


  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
   modesetting.enable = true;
   powerManagement.enable = false;
   powerManagement.finegrained = false;
   open = false;

   prime = {
       offload.enable = true;
       offload.enableOffloadCmd = true;

       intelBusId = "PCI:0:2:0";
       nvidiaBusId = "PCI:1:0:0";
     };

  };

  # packages
  programs.steam = {
   enable = true;
   package = pkgs.steam.override {
     extraProfile = ''
       export __NV_PRIME_RENDER_OFFLOAD=1
       export __GLX_VENDOR_LIBRARY_NAME=nvidia
       export __VK_LAYER_NV_optimus=NVIDIA_only
     '';
   };
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    discord-ptb
  ];

  system.stateVersion = "26.05";
  };

}
