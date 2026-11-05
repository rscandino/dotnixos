# flake.nix: wiring only, no configuration
{
  description = "NixOS flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    mangowm,
    ...
  }: let
    mkHost = name:
      nixpkgs.lib.nixosSystem {
        modules = [
          ./modules
          ./hosts/common
          ./hosts/${name}/configuration.nix
          mangowm.nixosModules.mango
        ];
      };
  in {
    nixosConfigurations = {
      zbook = mkHost "zbook";
    # newhost = mkHost "newhost";
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
