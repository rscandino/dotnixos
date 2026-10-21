{ config, lib, pkgs, ... }:
let cfg = config.moduleGaming; in
{
  options.moduleGaming.enable = lib.mkEnableOption "Steam and gamemode" // {default = false;};

  config = lib.mkIf cfg.enable {

      # STEAM install and setup
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

      # GAMEMODE
      programs.gamemode.enable = true;

      # DISCORD install
      environment.systemPackages = with pkgs; [ discord-ptb ];
  };
}
