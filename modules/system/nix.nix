{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.nix;
in {
  options.modules.system.nix.enable = lib.mkEnableOption "Nix flakes and gc settings";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    system.autoUpgrade.flake = {
      enable = true;
      dates = "weekly";
    };

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
