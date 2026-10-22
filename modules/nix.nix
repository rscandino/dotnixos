{
  config,
  lib,
  ...
}: let
  cfg = config.modNix;
in {
  options.modNix.enable = lib.mkEnableOption "Nix settings" // {default = false;};

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    system.autoUpgrade = {
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
