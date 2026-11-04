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
  }: {
    nixosConfigurations.zbook = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/zbook
        ./hosts/common
        ./modules

        mangowm.nixosModules.mango
        {
          programs.mango.enable = true;
        }
      ];
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
